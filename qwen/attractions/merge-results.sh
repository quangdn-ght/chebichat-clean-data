#!/bin/bash

echo "🔄 Merging worker results..."
echo ""

# Check if any worker results exist
if ! ls output/worker-*-results.json 1> /dev/null 2>&1; then
    echo "⚠️  No worker result files found in output/"
    echo ""
    echo "Make sure workers have completed processing."
    exit 1
fi

# Run the merge script
node merge-results.js

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Results merged successfully!"
    echo ""
    echo "📁 Output files:"
    echo "   output/merged-results.json       # All results combined"
    echo "   output/merged-errors.json        # Failed items only"
    echo "   output/processing-summary.json   # Summary statistics"
    echo ""
else
    echo ""
    echo "❌ Failed to merge results"
    exit 1
fi
