# Scripts Module - Shell Scripts và Automation

## 📋 Tổng quan

Module Scripts chứa các shell scripts để automation workflows, deployment, monitoring, và maintenance tasks. Đây là tập hợp các công cụ command-line để quản lý toàn bộ dictionary pipeline một cách hiệu quả.

## 📁 Files trong Module

### 1. `pm2.sh` - Quản lý PM2 Processes

**Chức năng:**
- 🚀 Start/stop/restart PM2 processes
- 📊 Monitor process status
- 🔄 Process management automation
- 📝 Log management shortcuts
- 🛠️ Deployment helpers

**Cách sử dụng:**
```bash
# Start all dictionary processes
./scripts/pm2.sh start

# Stop all processes
./scripts/pm2.sh stop

# Restart specific process
./scripts/pm2.sh restart dict-generator-1

# Show status
./scripts/pm2.sh status

# View logs
./scripts/pm2.sh logs
```

**Available Commands:**
```bash
# Process management
pm2.sh start [app-name]     # Start processes
pm2.sh stop [app-name]      # Stop processes  
pm2.sh restart [app-name]   # Restart processes
pm2.sh reload [app-name]    # Reload processes (zero-downtime)
pm2.sh delete [app-name]    # Delete processes

# Monitoring
pm2.sh status              # Show process status
pm2.sh logs [app-name]     # View logs
pm2.sh monit               # Open monitoring dashboard
pm2.sh info [app-name]     # Detailed process info

# Maintenance
pm2.sh flush               # Clear logs
pm2.sh dump                # Save process list
pm2.sh resurrect           # Restore processes
pm2.sh startup             # Setup startup script
```

### 2. `dictionary_summary.sh` - Tóm tắt Từ điển

**Chức năng:**
- 📊 Generate comprehensive dictionary statistics
- 📈 Progress tracking và reporting
- 🔍 Data quality assessment
- 📋 Summary report generation

**Output Example:**
```bash
=== DICTIONARY PROJECT SUMMARY ===
Generated: 2025-08-05 14:30:15

📊 PROCESSING STATISTICS:
- Total input items: 98,160
- Processed items: 97,845 (99.68%)
- Missing items: 315 (0.32%)
- Duplicate items removed: 4,800
- Final unique items: 93,045

📁 FILE STATISTICS:
- Batch files generated: 4,903
- Average file size: 2.3MB
- Total output size: 11.2GB
- Backup files: 150

🕒 TIMING INFORMATION:
- Processing started: 2025-08-04 09:15:00
- Processing completed: 2025-08-05 14:20:00
- Total processing time: 29h 5m
- Average speed: 54.2 items/minute

✅ QUALITY METRICS:
- Translation completeness: 98.7%
- Hanviet coverage: 87.3%
- Example sentences: 76.8%
- Data validation passed: 99.9%
```

### 3. `merge_complete_dictionary.sh` - Gộp Từ điển Hoàn chỉnh

**Chức năng:**
- 🔄 Complete merge workflow automation
- 📊 Pre-merge validation checks
- 🧹 Deduplication integration
- ✅ Post-merge verification
- 📝 Merge reporting

**Workflow:**
```bash
1. Pre-merge validation
2. Missing items check
3. Deduplication process
4. Main merge operation
5. Hanviet integration
6. Post-merge validation
7. Final report generation
```

**Usage:**
```bash
# Standard merge
./scripts/merge_complete_dictionary.sh

# Merge with specific options
./scripts/merge_complete_dictionary.sh --skip-dedup --no-hanviet

# Merge with validation only
./scripts/merge_complete_dictionary.sh --validate-only
```

### 4. `merge_complete_dictionary_enhanced.sh` - Gộp Nâng cao

**Chức năng:**
- 🚀 Enhanced merge với advanced features
- 🎯 Quality-based conflict resolution
- 📊 Advanced statistics generation
- 🔧 Custom merge strategies
- 💎 Premium quality assurance

**Enhanced Features:**
- Multi-strategy deduplication
- Quality score calculation
- Advanced conflict resolution
- Performance optimization
- Detailed analytics

### 5. `verify-merged-data.sh` - Xác minh Dữ liệu Gộp

**Chức năng:**
- ✅ Comprehensive data validation
- 🔍 Integrity checks
- 📊 Quality metrics calculation
- 🚨 Issue detection và reporting
- 📈 Validation reporting

**Validation Checks:**
```bash
=== DATA VERIFICATION REPORT ===

📊 STRUCTURE VALIDATION:
✅ JSON format validity: PASSED
✅ Required fields present: PASSED  
✅ Data type consistency: PASSED
✅ Character encoding: PASSED

🔍 CONTENT VALIDATION:
✅ Chinese character validity: PASSED
✅ Pinyin format validation: PASSED
✅ Vietnamese text encoding: PASSED
✅ No empty required fields: PASSED

📈 QUALITY METRICS:
✅ Translation completeness: 98.7%
✅ Duplicate detection: 0 duplicates found
✅ Cross-reference validation: PASSED
✅ Data consistency: 99.9%

🎯 COVERAGE ANALYSIS:
✅ HSK level coverage: COMPLETE (1-6)
✅ Character frequency coverage: 94.2%
✅ Example sentence coverage: 76.8%
```

### 6. `process_final_missing.sh` - Xử lý Thiếu Cuối

**Chức năng:**
- 🎯 Final missing items processing
- 🔄 Last-chance recovery workflows
- 🚨 Emergency processing procedures
- 📊 Final completion verification

**Process Flow:**
```bash
1. Identify final missing items
2. Analyze missing patterns
3. Apply recovery strategies
4. Process with fallback methods
5. Validate recovery results
6. Update main dictionary
7. Generate completion report
```

### 7. `process_final_simplified.sh` - Xử lý Đơn giản Cuối

**Chức năng:**
- 🎯 Simplified final processing
- ⚡ Fast completion workflow
- 🛡️ Safe processing mode
- 📋 Essential operations only

**Simplified Workflow:**
- Skip complex validations
- Use basic merge strategies
- Essential deduplication only
- Quick verification

### 8. `reprocess-errors.sh` - Xử lý lại Lỗi

**Chức năng:**
- 🚨 Error batch reprocessing
- 🔧 Error recovery automation
- 📊 Error analysis và reporting
- 🔄 Retry mechanisms

**Error Handling:**
```bash
=== ERROR REPROCESSING WORKFLOW ===

1. 🔍 IDENTIFY ERRORS:
   - Scan error logs
   - Parse failure patterns
   - Categorize error types

2. 🎯 ANALYZE PATTERNS:
   - API timeout errors: 45%
   - Rate limit errors: 30% 
   - Invalid response: 15%
   - Network errors: 10%

3. 🔧 APPLY FIXES:
   - Increase timeout for timeout errors
   - Add delays for rate limit errors
   - Retry with different params
   - Manual intervention for complex errors

4. ✅ VERIFY RESULTS:
   - Validate reprocessed items
   - Check data quality
   - Update success metrics
```

### 9. `fix_missing_items.sh` - Sửa Items Thiếu

**Chức năng:**
- 🔧 Automated missing item repair
- 🎯 Targeted item recovery
- 📊 Missing item analysis
- ✅ Recovery verification

### 10. `merge-reprocessed.sh` - Gộp Dữ liệu Xử lý lại

**Chức năng:**
- 🔄 Merge reprocessed items back
- 🎯 Conflict resolution automation
- 📊 Integration verification
- 📈 Quality improvement tracking

## 🔧 Script Usage Patterns

### Standard Workflow:
```bash
#!/bin/bash
# Complete dictionary generation workflow

echo "🚀 Starting complete dictionary workflow..."

# 1. Start generation processes
./scripts/pm2.sh start

# 2. Wait for completion (with monitoring)
./scripts/monitor_progress.sh

# 3. Process missing items
./scripts/process_final_missing.sh

# 4. Merge complete dictionary
./scripts/merge_complete_dictionary_enhanced.sh

# 5. Verify final data
./scripts/verify-merged-data.sh

# 6. Generate summary
./scripts/dictionary_summary.sh

echo "✅ Workflow completed successfully!"
```

### Error Recovery Workflow:
```bash
#!/bin/bash
# Error recovery and reprocessing

echo "🚨 Starting error recovery workflow..."

# 1. Stop current processes
./scripts/pm2.sh stop

# 2. Analyze errors
./scripts/analyze-errors.sh

# 3. Reprocess errors
./scripts/reprocess-errors.sh

# 4. Fix missing items
./scripts/fix_missing_items.sh

# 5. Merge recovered data
./scripts/merge-reprocessed.sh

# 6. Verify recovery
./scripts/verify-merged-data.sh

echo "✅ Recovery completed!"
```

### Maintenance Workflow:
```bash
#!/bin/bash
# Regular maintenance tasks

echo "🔧 Starting maintenance tasks..."

# 1. Cleanup old logs
find logs/ -name "*.log" -mtime +7 -delete

# 2. Archive old outputs
tar -czf "output-backup-$(date +%Y%m%d).tar.gz" output/

# 3. Check disk space
df -h | grep -E "(output|logs)"

# 4. Validate recent data
./scripts/verify-merged-data.sh --recent-only

# 5. Update statistics
./scripts/dictionary_summary.sh

echo "✅ Maintenance completed!"
```

## 📊 Script Configuration

### Environment Variables:
```bash
# Common script configurations
export DICT_ROOT="/path/to/dictionary"
export LOG_LEVEL="info"
export BACKUP_RETENTION_DAYS=30
export MAX_PARALLEL_PROCESSES=10
export API_TIMEOUT=30
export RETRY_ATTEMPTS=3

# Output formatting
export COLORED_OUTPUT=true
export PROGRESS_BARS=true
export TIMESTAMP_FORMAT="%Y-%m-%d %H:%M:%S"

# Performance settings
export MEMORY_LIMIT="4G"
export CPU_LIMIT=80
export DISK_SPACE_THRESHOLD=90
```

### Script Helpers:
```bash
# Common functions used across scripts
source scripts/common.sh

# Logging functions
log_info() { echo "ℹ️  [INFO] $1"; }
log_warn() { echo "⚠️  [WARN] $1"; }
log_error() { echo "❌ [ERROR] $1"; }
log_success() { echo "✅ [SUCCESS] $1"; }

# Progress tracking
show_progress() {
    local current=$1
    local total=$2
    local percent=$((current * 100 / total))
    printf "\rProgress: [%-50s] %d%%" $(printf "#%.0s" $(seq 1 $((percent/2)))) $percent
}

# Validation helpers
check_file_exists() {
    if [[ ! -f "$1" ]]; then
        log_error "File not found: $1"
        exit 1
    fi
}

check_disk_space() {
    local usage=$(df / | awk 'NR==2 {print $5}' | cut -d'%' -f1)
    if [[ $usage -gt $DISK_SPACE_THRESHOLD ]]; then
        log_warn "Disk space usage high: ${usage}%"
    fi
}
```

## 🚨 Error Handling

### Script Error Management:
```bash
# Enable strict error handling
set -euo pipefail

# Trap errors and cleanup
trap 'cleanup_on_error $? $LINENO' ERR

cleanup_on_error() {
    local exit_code=$1
    local line_number=$2
    
    log_error "Script failed at line $line_number with exit code $exit_code"
    
    # Cleanup temporary files
    rm -f /tmp/dict_temp_*
    
    # Stop any running processes
    ./scripts/pm2.sh stop 2>/dev/null || true
    
    # Send notification (if configured)
    send_alert "Dictionary script failed" "Error at line $line_number"
    
    exit $exit_code
}

# Timeout for long-running operations
timeout_command() {
    local timeout=$1
    shift
    timeout $timeout "$@" || {
        log_error "Command timed out after ${timeout}s: $*"
        return 1
    }
}
```

### Recovery Mechanisms:
```bash
# Retry mechanism for flaky operations
retry_command() {
    local max_attempts=$1
    shift
    local command="$@"
    local attempt=1
    
    while [[ $attempt -le $max_attempts ]]; do
        if eval "$command"; then
            return 0
        else
            log_warn "Attempt $attempt failed, retrying..."
            sleep $((attempt * 2))  # Exponential backoff
            ((attempt++))
        fi
    done
    
    log_error "All $max_attempts attempts failed for: $command"
    return 1
}
```

## 🧪 Script Testing

### Test Framework:
```bash
# Test runner for scripts
run_script_tests() {
    local test_dir="tests/scripts"
    local failed_tests=0
    
    for test_file in "$test_dir"/*.sh; do
        log_info "Running test: $(basename "$test_file")"
        
        if bash "$test_file"; then
            log_success "Test passed: $(basename "$test_file")"
        else
            log_error "Test failed: $(basename "$test_file")"
            ((failed_tests++))
        fi
    done
    
    if [[ $failed_tests -eq 0 ]]; then
        log_success "All tests passed!"
        return 0
    else
        log_error "$failed_tests test(s) failed"
        return 1
    fi
}
```

### Mock Testing:
```bash
# Mock external dependencies for testing
setup_test_environment() {
    export NODE_ENV="test"
    export API_MOCK="true"
    export OUTPUT_DIR="test-output"
    
    # Create test directories
    mkdir -p test-output test-logs test-input
    
    # Mock PM2 commands
    alias pm2='echo "Mock PM2:"'
}

teardown_test_environment() {
    unalias pm2 2>/dev/null || true
    rm -rf test-output test-logs test-input
}
```

---

**Module:** Scripts  
**Maintainer:** Automation Team  
**Last Updated:** 05/08/2025

*Module Scripts cung cấp automation cho toàn bộ workflow. Luôn test scripts trong test environment trước khi chạy production.*
