#!/bin/bash

echo "📋 Adding short_description columns to regions table..."
echo ""
echo "Please run the following SQL in Supabase SQL Editor:"
echo "Dashboard > SQL Editor > New Query"
echo ""
echo "=========================================="
cat add-short-description-columns.sql
echo "=========================================="
echo ""
echo "After running the SQL, test with:"
echo "  node test-query-regions.js"
