#!/bin/bash

# Script to run quotation generation for all quotations
# Configuration for optimal processing of 7103 quotations

echo "Starting quotation generation process..."
echo "Total quotations: 7103"
echo "Batch size: 10 (smaller batches for better quality)"
echo "Expected total batches: ~710"

# Clean up any existing output files
echo "Cleaning up existing output files..."
rm -f output/quotation_*.json
rm -f output/quotations-processed-*.json

# Run the quotation generator
echo "Running quotation generator..."
cd /home/ght/chebichat-project/chebichat-clean-data/qwen/dictionary

node src/core/quotationGenerate.js \
  --process-id=1 \
  --total-processes=1 \
  --batches-per-process=711

echo "Quotation generation completed!"
echo "Check output directory for results:"
echo "  - quotations-processed-process-1.json (final merged results)"
echo "  - Individual batch files: quotation_batch_*.json"
