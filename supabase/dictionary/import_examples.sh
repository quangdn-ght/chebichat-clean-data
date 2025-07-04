#!/bin/bash

# Dictionary Import Script
# Usage examples for importing Chinese-Vietnamese dictionary data

echo "🚀 Dictionary Import Tool - Usage Examples"
echo "=========================================="

# Set environment variables for configuration
export BATCH_SIZE=1000
export VALIDATE_DATA=true

# Example 1: Basic import with default settings
echo "📝 Example 1: Basic import"
echo "node dictionayImport.js"
echo ""

# Example 2: Custom input file and output directory
echo "📝 Example 2: Custom paths"
echo "node dictionayImport.js '../qwen/dictionary/output/dict-processed-process-1.json' './custom_output'"
echo ""

# Example 3: Large batch size for better performance
echo "📝 Example 3: Large batches (for powerful systems)"
echo "BATCH_SIZE=5000 node dictionayImport.js"
echo ""

# Example 4: Skip validation for faster processing
echo "📝 Example 4: Skip validation (faster but risky)"
echo "VALIDATE_DATA=false node dictionayImport.js"
echo ""

echo "📁 Expected Input File Structure:"
echo "================================="
cat << 'EOF'
[
  {
    "chinese": "它们",
    "pinyin": "tā men",
    "type": "đại từ",
    "meaning_vi": "Chúng (dùng để chỉ động vật hoặc đồ vật)",
    "meaning_en": "They/them (used to refer to animals or objects)",
    "example_cn": "我喜欢这些小狗，它们很可爱。",
    "example_vi": "Tôi thích những chú chó con này, chúng rất đáng yêu.",
    "example_en": "I like these puppies; they are very cute.",
    "grammar": "Đại từ số nhiều, dùng để chỉ các sự vật hoặc động vật không phải là người."
  },
  ...
]
EOF

echo ""
echo "📤 Generated Output Files:"
echo "=========================="
echo "• dictionary_setup_[timestamp].sql     - Schema creation"
echo "• dictionary_complete_[timestamp].sql  - All data in one file"
echo "• dictionary_batch_X_of_Y_[timestamp].sql - Individual batch files"
echo "• dictionary_stats_[timestamp].sql     - Statistics and verification"
echo ""

echo "🗄️  Database Setup Process:"
echo "============================"
echo "1. Run the setup file to create schema:"
echo "   psql -d your_database -f dictionary_setup_[timestamp].sql"
echo ""
echo "2. Import data (choose one method):"
echo "   a) Complete file (single transaction):"
echo "      psql -d your_database -f dictionary_complete_[timestamp].sql"
echo ""
echo "   b) Batch files (more control):"
echo "      for file in dictionary_batch_*_[timestamp].sql; do"
echo "        psql -d your_database -f \$file"
echo "      done"
echo ""
echo "3. Run statistics to verify:"
echo "   psql -d your_database -f dictionary_stats_[timestamp].sql"
echo ""

echo "⚡ Performance Tips:"
echo "==================="
echo "• For 12,000+ records, use batch size 1000-2000"
echo "• Run setup file first to create optimized indexes"
echo "• Use SSD storage for better performance"
echo "• Consider increasing PostgreSQL work_mem temporarily"
echo "• Monitor disk space (estimated ~50-100MB for 12K records)"
echo ""

echo "🔍 Search Examples After Import:"
echo "================================="
echo "-- Search Vietnamese meaning"
echo "SELECT * FROM search_dictionary_vietnamese('yêu thương') LIMIT 10;"
echo ""
echo "-- Search Chinese characters"
echo "SELECT * FROM search_dictionary_chinese('爱') LIMIT 10;"
echo ""
echo "-- Get statistics"
echo "SELECT * FROM dictionary_stats;"
echo ""

echo "🛠️  Troubleshooting:"
echo "===================="
echo "• If 'permission denied': chmod +x import_examples.sh"
echo "• If 'module not found': npm install (though no external deps required)"
echo "• If 'JSON parse error': check input file format"
echo "• If 'enum value error': check word type mappings in script"
echo "• For large files: increase Node.js heap size: node --max-old-space-size=4096"
echo ""

# Make this script executable
chmod +x "$0"

echo "✅ Ready to run! Choose an example above or customize as needed."
