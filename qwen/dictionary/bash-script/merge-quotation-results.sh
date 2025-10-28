#!/bin/bash

echo "🔄 Merging Multi-Worker Quotation Results"
echo "=========================================="

cd /home/ght/chebichat-project/chebichat-clean-data/qwen/dictionary

# Check if we have results from all workers
echo "📊 Checking worker results..."
total_files=0
total_quotations=0

for i in {1..8}; do
    file="output/quotations-processed-process-${i}.json"
    if [ -f "$file" ]; then
        count=$(cat "$file" | jq '. | length' 2>/dev/null || echo "0")
        echo "  Worker $i: $count quotations"
        total_quotations=$((total_quotations + count))
        total_files=$((total_files + 1))
    else
        echo "  Worker $i: file not found"
    fi
done

echo ""
echo "📈 Summary:"
echo "  Workers with results: $total_files / 8"
echo "  Total quotations: $total_quotations"
echo ""

if [ $total_files -eq 0 ]; then
    echo "❌ No worker results found. Make sure the processing is complete."
    exit 1
fi

# Create merged result
echo "🔧 Merging results..."
output_file="output/quotations-final-merged.json"

# Start with empty array
echo "[]" > "$output_file"

# Merge all worker files
for i in {1..8}; do
    file="output/quotations-processed-process-${i}.json"
    if [ -f "$file" ]; then
        echo "  Merging worker $i..."
        
        # Use jq to merge arrays
        temp_file=$(mktemp)
        jq -s '.[0] + .[1]' "$output_file" "$file" > "$temp_file"
        mv "$temp_file" "$output_file"
    fi
done

# Validate final result
final_count=$(cat "$output_file" | jq '. | length' 2>/dev/null || echo "0")
echo ""
echo "✅ Merge Complete!"
echo "  Final file: $output_file"
echo "  Total quotations: $final_count"

# Create a summary report
report_file="output/quotation-generation-report.json"
echo "📋 Creating summary report..."

cat > "$report_file" << EOF
{
  "generation_date": "$(date -Iseconds)",
  "total_quotations_processed": $final_count,
  "workers_used": $total_files,
  "expected_total": 7103,
  "completion_percentage": $(echo "scale=2; $final_count * 100 / 7103" | bc -l),
  "output_files": {
    "final_merged": "$output_file",
    "worker_files": [
EOF

# Add worker file info
for i in {1..8}; do
    file="output/quotations-processed-process-${i}.json"
    if [ -f "$file" ]; then
        count=$(cat "$file" | jq '. | length' 2>/dev/null || echo "0")
        if [ $i -gt 1 ] && [ -f "output/quotations-processed-process-$((i-1)).json" ]; then
            echo "," >> "$report_file"
        fi
        echo "      {\"worker\": $i, \"file\": \"$file\", \"quotations\": $count}" >> "$report_file"
    fi
done

cat >> "$report_file" << EOF
    ]
  },
  "sample_translation": $(head -n 50 "$output_file" | jq '.[0]' 2>/dev/null || echo "null")
}
EOF

echo "  Report file: $report_file"
echo ""

# Show sample of results
echo "📖 Sample Translation (first quotation):"
cat "$output_file" | jq '.[0]' 2>/dev/null | head -15 || echo "Unable to display sample"

echo ""
echo "🎉 Quotation generation and merging complete!"
echo ""
echo "📁 Output files:"
echo "  - Final merged: $output_file ($final_count quotations)"
echo "  - Report: $report_file"
echo "  - Individual workers: output/quotations-processed-process-*.json"
echo ""

if [ $final_count -lt 7000 ]; then
    echo "⚠️  Warning: Processed quotations ($final_count) is less than expected (7,103)"
    echo "   Check if all workers completed successfully or if there were errors."
fi
