#!/bin/bash
# Script to apply the user creation fix to Supabase database

echo "=========================================="
echo "Supabase User Creation Fix - Deployment"
echo "=========================================="
echo ""

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
    echo "✓ Loaded environment variables from .env"
else
    echo "✗ Error: .env file not found!"
    exit 1
fi

# Check required environment variables
if [ -z "$SUPABASE_URL" ]; then
    echo "✗ Error: SUPABASE_URL not set in .env"
    exit 1
fi

if [ -z "$SUPABASE_SERVICE_ROLE_KEY" ]; then
    echo "✗ Error: SUPABASE_SERVICE_ROLE_KEY not set in .env"
    exit 1
fi

echo "✓ Environment variables validated"
echo ""

# Extract database connection details from SUPABASE_URL
DB_HOST="${SUPABASE_URL#https://}"
DB_HOST="db.${DB_HOST#*.}"
PROJECT_ID=$(echo "$SUPABASE_URL" | sed 's/https:\/\/\(.*\)\.supabase\.co/\1/')

echo "Connection Details:"
echo "  Project ID: $PROJECT_ID"
echo "  Database Host: $DB_HOST"
echo ""

# Check if psql is installed
if ! command -v psql &> /dev/null; then
    echo "⚠ Warning: psql is not installed. Cannot run SQL directly."
    echo ""
    echo "Please run the SQL file manually:"
    echo "1. Go to https://app.supabase.com/project/$PROJECT_ID/sql/new"
    echo "2. Copy the contents of database/fix-user-creation.sql"
    echo "3. Paste and run in the SQL Editor"
    echo ""
    echo "Alternatively, install psql:"
    echo "  Ubuntu/Debian: sudo apt-get install postgresql-client"
    echo "  macOS: brew install postgresql"
    echo ""
    exit 0
fi

# Prompt for database password
echo "To run this fix, you need the database password."
echo "You can find it in your Supabase project settings:"
echo "  https://app.supabase.com/project/$PROJECT_ID/settings/database"
echo ""
read -sp "Enter database password (or press Ctrl+C to cancel): " DB_PASSWORD
echo ""
echo ""

if [ -z "$DB_PASSWORD" ]; then
    echo "✗ Error: No password provided"
    exit 1
fi

# Try to connect and run the SQL file
echo "Applying fix to database..."
echo ""

PGPASSWORD="$DB_PASSWORD" psql \
    -h "$DB_HOST" \
    -p 5432 \
    -U postgres \
    -d postgres \
    -f database/fix-user-creation.sql

if [ $? -eq 0 ]; then
    echo ""
    echo "=========================================="
    echo "✓ Fix applied successfully!"
    echo "=========================================="
    echo ""
    echo "Next steps:"
    echo "1. Test user creation through your application"
    echo "2. Check the verification queries in FIX_USER_CREATION_GUIDE.md"
    echo "3. Monitor Supabase logs for any errors"
    echo ""
else
    echo ""
    echo "=========================================="
    echo "✗ Error applying fix"
    echo "=========================================="
    echo ""
    echo "Please try applying the fix manually:"
    echo "1. Go to https://app.supabase.com/project/$PROJECT_ID/sql/new"
    echo "2. Copy the contents of database/fix-user-creation.sql"
    echo "3. Paste and run in the SQL Editor"
    echo ""
    exit 1
fi
