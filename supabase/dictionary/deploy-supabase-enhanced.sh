#!/bin/bash

# Enhanced Supabase Dictionary Deployment Script
# This script handles role permissions and deploys dictionary data to Supabase

set -e  # Exit on any error

# Configuration
OUTPUT_DIR="./output"
SCHEMA_FILE="../db/dictionary_schema.sql"
LOG_FILE="./deployment.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Error handling
error_exit() {
    echo -e "${RED}❌ Error: $1${NC}" >&2
    log "ERROR: $1"
    exit 1
}

# Success message
success() {
    echo -e "${GREEN}✅ $1${NC}"
    log "SUCCESS: $1"
}

# Warning message
warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
    log "WARNING: $1"
}

# Info message
info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
    log "INFO: $1"
}

# Check if required environment variables are set
check_environment() {
    info "Checking Supabase environment variables..."
    
    if [[ -z "$SUPABASE_PROJECT_ID" ]]; then
        error_exit "SUPABASE_PROJECT_ID environment variable is not set"
    fi
    
    if [[ -z "$SUPABASE_DB_PASSWORD" ]]; then
        error_exit "SUPABASE_DB_PASSWORD environment variable is not set"
    fi
    
    # Set default values if not provided
    export SUPABASE_HOST="${SUPABASE_HOST:-db.${SUPABASE_PROJECT_ID}.supabase.co}"
    export SUPABASE_PORT="${SUPABASE_PORT:-5432}"
    export SUPABASE_DATABASE="${SUPABASE_DATABASE:-postgres}"
    export SUPABASE_USER="${SUPABASE_USER:-postgres}"
    
    success "Environment variables validated"
    info "Project ID: $SUPABASE_PROJECT_ID"
    info "Host: $SUPABASE_HOST"
    info "Database: $SUPABASE_DATABASE"
    info "User: $SUPABASE_USER"
}

# Test Supabase connection with role verification
test_connection() {
    info "Testing Supabase connection and verifying roles..."
    
    # Create a temporary SQL file for testing
    local test_sql="/tmp/supabase_test_$$.sql"
    cat > "$test_sql" << 'EOF'
-- Test Supabase connection and roles
\timing off
\set QUIET on

-- Check connection info
SELECT 
    'Connected to: ' || current_database() as database_info,
    'User: ' || current_user as user_info,
    'Server version: ' || version() as version_info;

-- Check available roles
SELECT 'Available Supabase roles:' as info;
SELECT '  - ' || rolname as available_roles
FROM pg_roles 
WHERE rolname IN ('postgres', 'authenticated', 'anon', 'service_role')
ORDER BY rolname;

-- Test role switching capability
DO $$
BEGIN
    -- Try to set postgres role
    BEGIN
        SET ROLE postgres;
        RAISE NOTICE 'Role switching: SUCCESS - Can use postgres role';
        RESET ROLE;
    EXCEPTION
        WHEN insufficient_privilege THEN
            RAISE NOTICE 'Role switching: LIMITED - Cannot switch to postgres role';
        WHEN OTHERS THEN
            RAISE NOTICE 'Role switching: ERROR - %', SQLERRM;
    END;
END $$;

-- Check schema permissions
SELECT 
    'Schema permissions:' as info,
    has_schema_privilege('public', 'CREATE') as can_create_in_public,
    has_schema_privilege('public', 'USAGE') as can_use_public;

\set QUIET off
EOF

    # Execute test
    if PGPASSWORD="$SUPABASE_DB_PASSWORD" psql \
        -h "$SUPABASE_HOST" \
        -p "$SUPABASE_PORT" \
        -d "$SUPABASE_DATABASE" \
        -U "$SUPABASE_USER" \
        -f "$test_sql" \
        --quiet \
        2>/dev/null; then
        success "Supabase connection test passed"
    else
        error_exit "Failed to connect to Supabase database"
    fi
    
    # Cleanup
    rm -f "$test_sql"
}

# Deploy schema with role management
deploy_schema() {
    info "Deploying dictionary schema with Supabase role management..."
    
    if [[ ! -f "$SCHEMA_FILE" ]]; then
        error_exit "Schema file not found: $SCHEMA_FILE"
    fi
    
    # Create enhanced schema file with role management
    local enhanced_schema="/tmp/enhanced_schema_$$.sql"
    cat > "$enhanced_schema" << 'EOF'
-- Enhanced Dictionary Schema with Supabase Role Management
\timing on
\echo 'Starting schema deployment with role management...'

-- Switch to postgres role for schema operations
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'postgres') THEN
        SET ROLE postgres;
        RAISE NOTICE 'Using postgres role for schema operations';
    ELSE
        RAISE NOTICE 'Using current role: %', current_user;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Role management notice: %', SQLERRM;
END $$;

EOF
    
    # Append the original schema
    cat "$SCHEMA_FILE" >> "$enhanced_schema"
    
    # Add role restoration at the end
    cat >> "$enhanced_schema" << 'EOF'

-- Reset role after schema operations
DO $$
BEGIN
    RESET ROLE;
    RAISE NOTICE 'Role reset completed';
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Role reset completed with warnings';
END $$;

\echo 'Schema deployment completed!'
EOF

    # Execute enhanced schema
    if PGPASSWORD="$SUPABASE_DB_PASSWORD" psql \
        -h "$SUPABASE_HOST" \
        -p "$SUPABASE_PORT" \
        -d "$SUPABASE_DATABASE" \
        -U "$SUPABASE_USER" \
        -f "$enhanced_schema" \
        -v ON_ERROR_STOP=1; then
        success "Schema deployed successfully"
    else
        error_exit "Schema deployment failed"
    fi
    
    # Cleanup
    rm -f "$enhanced_schema"
}

# Deploy data files with role management
deploy_data() {
    info "Deploying dictionary data with role management..."
    
    # Find the latest set of SQL files
    local latest_files=($(ls -t "$OUTPUT_DIR"/dictionary_supabase_part_*_*.sql 2>/dev/null | head -10))
    
    if [[ ${#latest_files[@]} -eq 0 ]]; then
        error_exit "No dictionary SQL files found in $OUTPUT_DIR"
    fi
    
    info "Found ${#latest_files[@]} data files to deploy"
    
    # Extract timestamp from first file to group related files
    local timestamp=$(echo "${latest_files[0]}" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}-[0-9]{2}-[0-9]{2}-[0-9]{3}Z')
    if [[ -n "$timestamp" ]]; then
        # Filter files with the same timestamp
        latest_files=($(ls "$OUTPUT_DIR"/dictionary_supabase_part_*_"$timestamp".sql 2>/dev/null | sort))
        info "Deploying files from batch: $timestamp"
    fi
    
    # Deploy each file
    local success_count=0
    for sql_file in "${latest_files[@]}"; do
        info "Deploying: $(basename "$sql_file")"
        
        if PGPASSWORD="$SUPABASE_DB_PASSWORD" psql \
            -h "$SUPABASE_HOST" \
            -p "$SUPABASE_PORT" \
            -d "$SUPABASE_DATABASE" \
            -U "$SUPABASE_USER" \
            -f "$sql_file" \
            -v ON_ERROR_STOP=1 \
            --quiet; then
            success "Deployed: $(basename "$sql_file")"
            ((success_count++))
        else
            error_exit "Failed to deploy: $(basename "$sql_file")"
        fi
    done
    
    success "Successfully deployed $success_count data files"
}

# Verify deployment and show statistics
verify_deployment() {
    info "Verifying deployment and gathering statistics..."
    
    local verify_sql="/tmp/verify_$$.sql"
    cat > "$verify_sql" << 'EOF'
-- Verify Dictionary Deployment
\timing off
\echo 'Verifying dictionary deployment...'

-- Check table exists and has data
SELECT 
    'Dictionary table status:' as info,
    COUNT(*) as total_records,
    COUNT(DISTINCT type) as unique_types,
    MIN(created_at) as earliest_entry,
    MAX(created_at) as latest_entry
FROM dictionary;

-- Check by word type
SELECT 
    'Records by type:' as info;
SELECT 
    type,
    COUNT(*) as count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) as percentage
FROM dictionary 
GROUP BY type 
ORDER BY count DESC;

-- Check recent imports
SELECT 
    'Recent imports (last hour):' as info,
    COUNT(*) as recent_records
FROM dictionary 
WHERE created_at >= NOW() - INTERVAL '1 hour';

-- Verify indexes
SELECT 
    'Database indexes:' as info;
SELECT 
    indexname,
    indexdef
FROM pg_indexes 
WHERE tablename = 'dictionary'
ORDER BY indexname;

-- Check permissions for Supabase roles
DO $$
DECLARE
    role_name text;
    perm_info text;
BEGIN
    FOR role_name IN SELECT rolname FROM pg_roles WHERE rolname IN ('authenticated', 'anon') LOOP
        IF has_table_privilege(role_name, 'dictionary', 'SELECT') THEN
            perm_info := role_name || ': SELECT ✓';
        ELSE
            perm_info := role_name || ': SELECT ✗';
        END IF;
        RAISE NOTICE '%', perm_info;
    END LOOP;
END $$;

\echo 'Verification completed!'
EOF

    if PGPASSWORD="$SUPABASE_DB_PASSWORD" psql \
        -h "$SUPABASE_HOST" \
        -p "$SUPABASE_PORT" \
        -d "$SUPABASE_DATABASE" \
        -U "$SUPABASE_USER" \
        -f "$verify_sql"; then
        success "Deployment verification completed"
    else
        warning "Verification completed with warnings"
    fi
    
    # Cleanup
    rm -f "$verify_sql"
}

# Main deployment function
main() {
    echo -e "${BLUE}🚀 Enhanced Supabase Dictionary Deployment${NC}"
    echo "================================================"
    log "Starting enhanced deployment process"
    
    # Initialize log file
    > "$LOG_FILE"
    
    # Step 1: Check environment
    check_environment
    
    # Step 2: Test connection and roles
    test_connection
    
    # Step 3: Deploy schema
    deploy_schema
    
    # Step 4: Deploy data
    deploy_data
    
    # Step 5: Verify deployment
    verify_deployment
    
    echo ""
    echo -e "${GREEN}🎉 Dictionary deployment completed successfully!${NC}"
    log "Deployment completed successfully"
    
    echo ""
    echo "📋 Summary:"
    echo "  - Schema: ✅ Deployed"
    echo "  - Data: ✅ Deployed"
    echo "  - Verification: ✅ Completed"
    echo "  - Log: $LOG_FILE"
    echo ""
    echo "🔗 Your dictionary is ready at: https://${SUPABASE_PROJECT_ID}.supabase.co"
}

# Check if running in source mode
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
