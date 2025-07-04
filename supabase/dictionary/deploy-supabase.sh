#!/bin/bash

# Supabase Dictionary Deployment Script
# Automatically deploys dictionary SQL files to Supabase with proper role permissions

# Configuration - Update these with your Supabase credentials
SUPABASE_PROJECT_ID="${SUPABASE_PROJECT_ID:-your-project-id}"
SUPABASE_DB_PASSWORD="${SUPABASE_DB_PASSWORD:-your-password}"
SUPABASE_HOST="${SUPABASE_HOST:-db.${SUPABASE_PROJECT_ID}.supabase.co}"
SUPABASE_PORT="${SUPABASE_PORT:-5432}"
SUPABASE_DATABASE="${SUPABASE_DATABASE:-postgres}"
SUPABASE_USER="${SUPABASE_USER:-postgres}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check prerequisites
check_prerequisites() {
    log "Checking prerequisites..."
    
    # Check if psql is installed
    if ! command -v psql &> /dev/null; then
        error "psql is not installed. Please install PostgreSQL client tools."
        exit 1
    fi
    
    # Check if required environment variables are set
    if [[ "$SUPABASE_PROJECT_ID" == "your-project-id" ]] || [[ -z "$SUPABASE_PROJECT_ID" ]]; then
        error "Please set SUPABASE_PROJECT_ID environment variable or update the script"
        exit 1
    fi
    
    if [[ "$SUPABASE_DB_PASSWORD" == "your-password" ]] || [[ -z "$SUPABASE_DB_PASSWORD" ]]; then
        error "Please set SUPABASE_DB_PASSWORD environment variable or update the script"
        exit 1
    fi
    
    success "Prerequisites check passed"
}

# Build connection string
build_connection_string() {
    echo "postgresql://${SUPABASE_USER}:${SUPABASE_DB_PASSWORD}@${SUPABASE_HOST}:${SUPABASE_PORT}/${SUPABASE_DATABASE}"
}

# Test database connection
test_connection() {
    log "Testing Supabase database connection..."
    
    local conn_string=$(build_connection_string)
    
    if psql "$conn_string" -c "SELECT version();" &> /dev/null; then
        success "Connected to Supabase database successfully"
        return 0
    else
        error "Failed to connect to Supabase database"
        error "Please check your credentials and network connectivity"
        return 1
    fi
}

# Setup Supabase roles and permissions
setup_supabase_roles() {
    log "Setting up Supabase roles and permissions..."
    
    local conn_string=$(build_connection_string)
    
    # Create SQL for role setup
    cat > /tmp/supabase_roles_setup.sql << 'EOF'
-- Supabase Role Setup for Dictionary Import
-- This script sets up proper permissions for dictionary operations

-- Enable required extensions (if not already enabled)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";
CREATE EXTENSION IF NOT EXISTS "unaccent";

-- Create a specific role for dictionary operations
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'dictionary_admin') THEN
        CREATE ROLE dictionary_admin;
    END IF;
END $$;

-- Grant necessary permissions to dictionary_admin role
GRANT ALL PRIVILEGES ON SCHEMA public TO dictionary_admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO dictionary_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO dictionary_admin;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO dictionary_admin;

-- Grant dictionary_admin role to postgres (main Supabase user)
GRANT dictionary_admin TO postgres;

-- Set up RLS policies if needed (Supabase specific)
DO $$
BEGIN
    -- Disable RLS for dictionary table during import (can be re-enabled later)
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'dictionary') THEN
        ALTER TABLE dictionary DISABLE ROW LEVEL SECURITY;
    END IF;
END $$;

-- Create import session configuration
CREATE OR REPLACE FUNCTION setup_import_session()
RETURNS void AS $func$
BEGIN
    -- Optimize for bulk import
    SET work_mem = '256MB';
    SET maintenance_work_mem = '1GB';
    SET checkpoint_completion_target = 0.9;
    SET wal_buffers = '16MB';
    
    -- Disable unnecessary logging during import
    SET log_statement = 'none';
    SET log_min_duration_statement = -1;
END;
$func$ LANGUAGE plpgsql;

-- Create cleanup function
CREATE OR REPLACE FUNCTION cleanup_import_session()
RETURNS void AS $func$
BEGIN
    -- Reset to defaults
    RESET work_mem;
    RESET maintenance_work_mem;
    RESET checkpoint_completion_target;
    RESET wal_buffers;
    RESET log_statement;
    RESET log_min_duration_statement;
END;
$func$ LANGUAGE plpgsql;

SELECT 'Supabase roles and permissions setup completed' as status;
EOF

    if psql "$conn_string" -f /tmp/supabase_roles_setup.sql; then
        success "Supabase roles and permissions configured"
        rm -f /tmp/supabase_roles_setup.sql
    else
        error "Failed to setup Supabase roles"
        return 1
    fi
}

# Deploy schema
deploy_schema() {
    log "Deploying dictionary schema..."
    
    local conn_string=$(build_connection_string)
    local schema_file="../db/dictionary_schema.sql"
    
    if [[ ! -f "$schema_file" ]]; then
        error "Schema file not found: $schema_file"
        return 1
    fi
    
    if psql "$conn_string" -f "$schema_file"; then
        success "Schema deployed successfully"
    else
        error "Failed to deploy schema"
        return 1
    fi
}

# Find and deploy SQL files
deploy_dictionary_data() {
    log "Deploying dictionary data..."
    
    local conn_string=$(build_connection_string)
    local output_dir="./output"
    
    # Find the latest timestamp files
    local latest_timestamp=$(ls ${output_dir}/dictionary_supabase_part_*_*.sql 2>/dev/null | head -1 | sed -n 's/.*_\([0-9T:-]*\)\.sql/\1/p')
    
    if [[ -z "$latest_timestamp" ]]; then
        error "No dictionary SQL files found in $output_dir"
        error "Please run: node dictionayImport.js bulk"
        return 1
    fi
    
    log "Found files with timestamp: $latest_timestamp"
    
    # Setup import session
    log "Setting up optimized import session..."
    psql "$conn_string" -c "SELECT setup_import_session();"
    
    # Check if we have master script or individual parts
    local master_file="${output_dir}/dictionary_supabase_master_${latest_timestamp}.sql"
    
    if [[ -f "$master_file" ]]; then
        log "Using master script for coordinated import..."
        if psql "$conn_string" -f "$master_file"; then
            success "Master script executed successfully"
        else
            error "Master script execution failed"
            return 1
        fi
    else
        # Import individual parts
        log "Importing individual part files..."
        local part_files=(${output_dir}/dictionary_supabase_part_*_${latest_timestamp}.sql)
        
        for part_file in "${part_files[@]}"; do
            if [[ -f "$part_file" ]]; then
                log "Importing $(basename "$part_file")..."
                if psql "$conn_string" -f "$part_file"; then
                    success "$(basename "$part_file") imported successfully"
                else
                    error "Failed to import $(basename "$part_file")"
                    return 1
                fi
            fi
        done
    fi
    
    # Cleanup import session
    log "Cleaning up import session..."
    psql "$conn_string" -c "SELECT cleanup_import_session();"
    
    # Run verification
    local verify_file="${output_dir}/dictionary_supabase_verify_${latest_timestamp}.sql"
    if [[ -f "$verify_file" ]]; then
        log "Running import verification..."
        psql "$conn_string" -f "$verify_file"
    fi
    
    success "Dictionary data deployment completed"
}

# Enable RLS (if required)
enable_rls() {
    log "Configuring Row Level Security (optional)..."
    
    local conn_string=$(build_connection_string)
    
    cat > /tmp/enable_rls.sql << 'EOF'
-- Enable RLS for production use
ALTER TABLE dictionary ENABLE ROW LEVEL SECURITY;

-- Create basic RLS policy (customize as needed)
CREATE POLICY "Allow read access to dictionary" ON dictionary
    FOR SELECT USING (true);

-- Grant access to authenticated users (Supabase auth)
CREATE POLICY "Allow authenticated access" ON dictionary
    FOR ALL USING (auth.role() = 'authenticated');

SELECT 'RLS enabled for dictionary table' as status;
EOF

    if psql "$conn_string" -f /tmp/enable_rls.sql 2>/dev/null; then
        success "Row Level Security configured"
    else
        warning "RLS configuration skipped (may already be configured)"
    fi
    
    rm -f /tmp/enable_rls.sql
}

# Main deployment function
deploy() {
    log "🚀 Starting Supabase Dictionary Deployment"
    log "Project ID: $SUPABASE_PROJECT_ID"
    log "Host: $SUPABASE_HOST"
    
    check_prerequisites || exit 1
    test_connection || exit 1
    setup_supabase_roles || exit 1
    deploy_schema || exit 1
    deploy_dictionary_data || exit 1
    
    # Optional: Enable RLS
    read -p "Do you want to enable Row Level Security? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        enable_rls
    fi
    
    success "🎉 Dictionary deployment completed successfully!"
    
    # Show final statistics
    log "Getting final database statistics..."
    local conn_string=$(build_connection_string)
    psql "$conn_string" -c "
        SELECT 
            'Dictionary Statistics' as info,
            COUNT(*) as total_records,
            COUNT(DISTINCT type) as unique_types,
            COUNT(DISTINCT chinese) as unique_words,
            pg_size_pretty(pg_total_relation_size('dictionary')) as table_size
        FROM dictionary;
        
        SELECT 'Top 5 word types:' as info;
        SELECT type, COUNT(*) as count 
        FROM dictionary 
        GROUP BY type 
        ORDER BY count DESC 
        LIMIT 5;
    "
}

# Generate environment template
generate_env_template() {
    cat > .env.example << 'EOF'
# Supabase Configuration
# Copy this file to .env and fill in your actual values

# Your Supabase project ID (found in Supabase dashboard)
SUPABASE_PROJECT_ID=your-project-id-here

# Your Supabase database password (postgres user password)
SUPABASE_DB_PASSWORD=your-database-password-here

# Optional: Override default connection settings
# SUPABASE_HOST=db.your-project-id.supabase.co
# SUPABASE_PORT=5432
# SUPABASE_DATABASE=postgres
# SUPABASE_USER=postgres
EOF
    
    success "Created .env.example template"
    log "Copy .env.example to .env and update with your Supabase credentials"
}

# Load environment variables from .env file if it exists
load_env() {
    if [[ -f ".env" ]]; then
        log "Loading environment variables from .env file..."
        export $(cat .env | grep -v '^#' | xargs)
    fi
}

# Usage information
usage() {
    echo "Supabase Dictionary Deployment Script"
    echo ""
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  deploy          Deploy dictionary to Supabase (default)"
    echo "  test            Test database connection"
    echo "  setup-roles     Setup Supabase roles and permissions only"
    echo "  schema          Deploy schema only"
    echo "  data            Deploy data only"
    echo "  env-template    Generate .env template file"
    echo "  help            Show this help"
    echo ""
    echo "Environment Variables:"
    echo "  SUPABASE_PROJECT_ID     Your Supabase project ID (required)"
    echo "  SUPABASE_DB_PASSWORD    Your database password (required)"
    echo "  SUPABASE_HOST          Database host (optional)"
    echo "  SUPABASE_PORT          Database port (optional)"
    echo "  SUPABASE_DATABASE      Database name (optional)"
    echo "  SUPABASE_USER          Database user (optional)"
    echo ""
    echo "Examples:"
    echo "  # Deploy everything"
    echo "  SUPABASE_PROJECT_ID=abc123 SUPABASE_DB_PASSWORD=mypass $0 deploy"
    echo ""
    echo "  # Or use .env file"
    echo "  $0 env-template  # Create template"
    echo "  cp .env.example .env  # Copy and edit"
    echo "  $0 deploy  # Deploy using .env"
}

# Main script
main() {
    load_env
    
    local command="${1:-deploy}"
    
    case "$command" in
        "deploy")
            deploy
            ;;
        "test")
            check_prerequisites && test_connection
            ;;
        "setup-roles")
            check_prerequisites && test_connection && setup_supabase_roles
            ;;
        "schema")
            check_prerequisites && test_connection && deploy_schema
            ;;
        "data")
            check_prerequisites && test_connection && deploy_dictionary_data
            ;;
        "env-template")
            generate_env_template
            ;;
        "help"|"-h"|"--help")
            usage
            ;;
        *)
            error "Unknown command: $command"
            usage
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
