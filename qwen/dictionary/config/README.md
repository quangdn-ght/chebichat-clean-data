# Configuration Module - Cấu hình Hệ thống

## 📋 Tổng quan

Module Configuration chứa các files cấu hình cho PM2 process management, environment settings, và deployment configurations. Đây là trung tâm quản lý tất cả các settings cho production và development environments.

## 📁 Files trong Module

### 1. `ecosystem.config.js` - Cấu hình PM2 Chính

**Chức năng:**
- 🚀 Cấu hình PM2 cho production deployment
- ⚡ Multi-process management cho dictionary generation
- 📊 Process monitoring và auto-restart
- 🔄 Load balancing configuration
- 📝 Logging và error handling setup

**Cấu trúc:**
```javascript
module.exports = {
  apps: [
    {
      name: 'dict-generator-1',
      script: 'src/core/dictionaryGenerate.js',
      args: '--process-id=1 --total-processes=10 --batches-per-process=60',
      instances: 1,
      exec_mode: 'fork',
      env: {
        NODE_ENV: 'production',
        PROCESS_ID: 1
      }
    },
    // ... more processes
  ]
};
```

**Usage:**
```bash
# Start all processes
pm2 start ecosystem.config.js

# Start specific app
pm2 start ecosystem.config.js --only dict-generator-1

# Reload all apps
pm2 reload ecosystem.config.js
```

### 2. `ecosystem.config.cjs` - CommonJS Configuration

**Chức năng:**
- 📦 CommonJS format cho compatibility
- 🔧 Legacy support cho older Node.js versions
- ⚙️ Alternative configuration format
- 🛡️ Fallback configuration

**Differences from ES6 version:**
- Uses `module.exports` instead of `export`
- Compatible với older Node.js versions
- Can be loaded với `require()`

### 3. `ecosystem.missing.config.cjs` - Missing Items Processing Config

**Chức năng:**
- 🎯 Specialized configuration cho missing items processing
- 🔄 Optimized settings cho recovery workflows
- ⚡ High-priority processing configuration
- 🚨 Emergency recovery settings

**Cấu trúc:**
```javascript
module.exports = {
  apps: [
    {
      name: 'missing-processor',
      script: 'src/missing-items/reprocess_missing_parallel.js',
      instances: 'max',
      exec_mode: 'cluster',
      max_memory_restart: '2G',
      env: {
        NODE_ENV: 'recovery',
        PRIORITY: 'high'
      }
    }
  ]
};
```

## 🔧 Configuration Structure

### Standard PM2 App Configuration:
```javascript
const appConfig = {
    // Basic settings
    name: 'app-name',                    // Unique app name
    script: 'path/to/script.js',         // Script to run
    args: '--arg1=value1 --arg2=value2', // Command line arguments
    
    // Execution settings
    instances: 1,                        // Number of instances
    exec_mode: 'fork',                   // 'fork' or 'cluster'
    node_args: '--max-old-space-size=4096', // Node.js arguments
    
    // Environment
    env: {
        NODE_ENV: 'production',
        API_KEY: 'your-api-key'
    },
    env_development: {
        NODE_ENV: 'development',
        API_KEY: 'dev-api-key'
    },
    
    // Process management
    max_memory_restart: '2G',            // Restart if memory exceeds
    max_restarts: 10,                    // Max restarts per hour
    min_uptime: '10s',                   // Min uptime before restart
    restart_delay: 4000,                 // Delay between restarts
    
    // Logging
    log_file: './logs/combined.log',
    out_file: './logs/out.log',
    error_file: './logs/error.log',
    log_date_format: 'YYYY-MM-DD HH:mm:ss Z',
    
    // Advanced settings
    watch: false,                        // Watch file changes
    ignore_watch: ['node_modules', 'logs'],
    autorestart: true,                   // Auto restart on crash
    time: true                           // Prefix logs with time
};
```

### Multi-Process Configuration Pattern:
```javascript
// Generate multiple dictionary processes
function generateDictProcesses(totalProcesses = 10) {
    const processes = [];
    
    for (let i = 1; i <= totalProcesses; i++) {
        processes.push({
            name: `dict-generator-${i}`,
            script: 'src/core/dictionaryGenerate.js',
            args: `--process-id=${i} --total-processes=${totalProcesses} --batches-per-process=60`,
            instances: 1,
            exec_mode: 'fork',
            max_memory_restart: '2G',
            env: {
                NODE_ENV: 'production',
                PROCESS_ID: i,
                TOTAL_PROCESSES: totalProcesses
            },
            error_file: `./logs/dict-generator-${i}-error.log`,
            out_file: `./logs/dict-generator-${i}-out.log`
        });
    }
    
    return processes;
}
```

## 🌍 Environment Configurations

### Production Environment:
```javascript
const productionConfig = {
    env: {
        NODE_ENV: 'production',
        DASHSCOPE_API_KEY: process.env.DASHSCOPE_API_KEY,
        BATCH_SIZE: 20,
        BATCH_DELAY: 2000,
        MAX_RETRIES: 3,
        LOG_LEVEL: 'info',
        OUTPUT_DIR: './output',
        INPUT_DIR: './input'
    },
    
    // Production optimizations
    max_memory_restart: '2G',
    instances: 'max',
    exec_mode: 'cluster',
    autorestart: true,
    max_restarts: 5
};
```

### Development Environment:
```javascript
const developmentConfig = {
    env_development: {
        NODE_ENV: 'development',
        DASHSCOPE_API_KEY: 'dev-key',
        BATCH_SIZE: 5,
        BATCH_DELAY: 1000,
        MAX_RETRIES: 1,
        LOG_LEVEL: 'debug',
        OUTPUT_DIR: './test-output',
        INPUT_DIR: './test-input'
    },
    
    // Development settings
    watch: true,
    ignore_watch: ['node_modules', 'logs', 'output'],
    instances: 1,
    exec_mode: 'fork'
};
```

### Testing Environment:
```javascript
const testingConfig = {
    env_testing: {
        NODE_ENV: 'test',
        API_MOCK: true,
        BATCH_SIZE: 2,
        BATCH_DELAY: 100,
        MAX_RETRIES: 1,
        LOG_LEVEL: 'error',
        OUTPUT_DIR: './test-output'
    }
};
```

## 📊 Monitoring Configuration

### PM2 Monitoring Setup:
```javascript
const monitoringConfig = {
    // PM2 Plus monitoring
    pmx: true,
    
    // Custom metrics
    monitoring: {
        http: true,
        custom_probes: [
            {
                name: 'items_processed',
                type: 'counter'
            },
            {
                name: 'api_response_time',
                type: 'histogram'
            },
            {
                name: 'memory_usage',
                type: 'gauge'
            }
        ]
    },
    
    // Health checks
    health_check: {
        endpoint: '/health',
        interval: 30000,
        timeout: 5000
    }
};
```

### Log Configuration:
```javascript
const loggingConfig = {
    // Log rotation
    log_file: './logs/combined.log',
    out_file: './logs/out.log',
    error_file: './logs/error.log',
    
    // Log format
    log_date_format: 'YYYY-MM-DD HH:mm:ss Z',
    merge_logs: true,
    
    // Log rotation settings (external logrotate)
    logRotation: {
        max_size: '100M',
        max_files: 10,
        compress: true
    }
};
```

## 🚀 Deployment Strategies

### Blue-Green Deployment:
```javascript
// ecosystem.blue.config.js
module.exports = {
    deploy: {
        blue: {
            user: 'deploy',
            host: 'blue.server.com',
            ref: 'origin/master',
            repo: 'git@github.com:user/repo.git',
            path: '/var/www/dict-blue',
            'post-deploy': 'npm install && pm2 reload ecosystem.config.js --env production'
        }
    }
};

// ecosystem.green.config.js  
module.exports = {
    deploy: {
        green: {
            user: 'deploy',
            host: 'green.server.com',
            ref: 'origin/master',
            repo: 'git@github.com:user/repo.git',
            path: '/var/www/dict-green',
            'post-deploy': 'npm install && pm2 reload ecosystem.config.js --env production'
        }
    }
};
```

### Rolling Deployment:
```javascript
const rollingDeployment = {
    instances: 10,
    exec_mode: 'cluster',
    
    // Rolling restart settings
    wait_ready: true,
    listen_timeout: 10000,
    kill_timeout: 5000,
    
    // Health check before considering ready
    health_check_grace_period: 3000
};
```

## 🔧 Advanced Configuration

### Resource Management:
```javascript
const resourceConfig = {
    // Memory management
    max_memory_restart: '2G',
    memory_limit: '1.5G',
    
    // CPU management
    exec_mode: 'cluster',
    instances: 'max',  // Use all CPU cores
    
    // Process limits
    max_restarts: 10,
    min_uptime: '10s',
    restart_delay: 4000,
    
    // File descriptors
    max_files: 10000
};
```

### Error Handling Configuration:
```javascript
const errorHandlingConfig = {
    // Restart policies
    autorestart: true,
    max_restarts: 5,
    restart_delay: 4000,
    
    // Error detection
    min_uptime: '10s',
    
    // Custom error handling
    error_file: './logs/error.log',
    combine_logs: true,
    
    // Crash recovery
    crash_recovery: {
        enabled: true,
        max_attempts: 3,
        backoff_strategy: 'exponential'
    }
};
```

### Load Balancing:
```javascript
const loadBalancingConfig = {
    instances: 'max',
    exec_mode: 'cluster',
    
    // Load balancing strategy
    instance_var: 'INSTANCE_ID',
    
    // Session affinity (if needed)
    sticky_sessions: false,
    
    // Health checks
    health_check: {
        endpoint: '/health',
        interval: 30000,
        max_failures: 3
    }
};
```

## 🧪 Testing Configurations

### Unit Test Configuration:
```javascript
const testConfig = {
    name: 'dict-test',
    script: 'npm',
    args: 'test',
    env: {
        NODE_ENV: 'test',
        API_MOCK: true
    },
    autorestart: false,
    watch: true,
    ignore_watch: ['node_modules', 'coverage']
};
```

### Integration Test Configuration:
```javascript
const integrationTestConfig = {
    name: 'dict-integration-test',
    script: 'src/testing/test-refactored.js',
    env: {
        NODE_ENV: 'integration',
        USE_REAL_API: false,
        SAMPLE_SIZE: 100
    },
    autorestart: false
};
```

## 📋 Configuration Management

### Environment-specific Configs:
```bash
# Load different configs based on environment
pm2 start ecosystem.config.js --env production
pm2 start ecosystem.config.js --env development
pm2 start ecosystem.config.js --env testing
```

### Configuration Validation:
```javascript
function validateConfig(config) {
    const requiredFields = ['name', 'script'];
    const errors = [];
    
    config.apps?.forEach((app, index) => {
        requiredFields.forEach(field => {
            if (!app[field]) {
                errors.push(`App ${index}: Missing required field '${field}'`);
            }
        });
        
        if (app.instances === 'max' && app.exec_mode !== 'cluster') {
            errors.push(`App ${index}: instances='max' requires exec_mode='cluster'`);
        }
    });
    
    return errors;
}
```

## 🛠️ Configuration Templates

### Basic Dictionary Generator:
```javascript
// Template for basic dictionary generation
const basicTemplate = {
    name: 'dict-basic',
    script: 'src/core/dictionaryGenerate.js',
    instances: 1,
    exec_mode: 'fork',
    max_memory_restart: '1G'
};
```

### High-Performance Template:
```javascript
// Template for high-performance processing
const highPerfTemplate = {
    name: 'dict-highperf',
    script: 'src/core/dictionaryGenerate.js',
    instances: 'max',
    exec_mode: 'cluster',
    max_memory_restart: '4G',
    node_args: '--max-old-space-size=4096'
};
```

---

**Module:** Configuration  
**Maintainer:** DevOps Team  
**Last Updated:** 05/08/2025

*Module Configuration quản lý tất cả deployment settings. Always validate configs trước khi deploy production.*
