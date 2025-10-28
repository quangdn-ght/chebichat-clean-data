module.exports = {
  apps: [
    {
      name: 'greeting-generator-1',
      script: './src/core/greetingGenerate.js',
      args: '--process-id=1 --total-processes=8 --batches-per-process=500',
      cwd: '/home/ght/chebichat-project/chebichat-clean-data/qwen/dictionary',
      instances: 1,
      autorestart: false,
      watch: false,
      max_memory_restart: '1G',
      env: {
        NODE_ENV: 'production',
        BATCH_SIZE: 8,
        BATCH_DELAY: 3000
      },
      log_file: './logs/greeting-1-combined.log',
      out_file: './logs/greeting-1-out.log',
      error_file: './logs/greeting-1-error.log',
      time: true
    },
    {
      name: 'greeting-generator-2',
      script: './src/core/greetingGenerate.js',
      args: '--process-id=2 --total-processes=8 --batches-per-process=500',
      cwd: '/home/ght/chebichat-project/chebichat-clean-data/qwen/dictionary',
      instances: 1,
      autorestart: false,
      watch: false,
      max_memory_restart: '1G',
      env: {
        NODE_ENV: 'production',
        BATCH_SIZE: 8,
        BATCH_DELAY: 3000
      },
      log_file: './logs/greeting-2-combined.log',
      out_file: './logs/greeting-2-out.log',
      error_file: './logs/greeting-2-error.log',
      time: true
    },
    {
      name: 'greeting-generator-3',
      script: './src/core/greetingGenerate.js',
      args: '--process-id=3 --total-processes=8 --batches-per-process=500',
      cwd: '/home/ght/chebichat-project/chebichat-clean-data/qwen/dictionary',
      instances: 1,
      autorestart: false,
      watch: false,
      max_memory_restart: '1G',
      env: {
        NODE_ENV: 'production',
        BATCH_SIZE: 8,
        BATCH_DELAY: 3000
      },
      log_file: './logs/greeting-3-combined.log',
      out_file: './logs/greeting-3-out.log',
      error_file: './logs/greeting-3-error.log',
      time: true
    },
    {
      name: 'greeting-generator-4',
      script: './src/core/greetingGenerate.js',
      args: '--process-id=4 --total-processes=8 --batches-per-process=500',
      cwd: '/home/ght/chebichat-project/chebichat-clean-data/qwen/dictionary',
      instances: 1,
      autorestart: false,
      watch: false,
      max_memory_restart: '1G',
      env: {
        NODE_ENV: 'production',
        BATCH_SIZE: 8,
        BATCH_DELAY: 3000
      },
      log_file: './logs/greeting-4-combined.log',
      out_file: './logs/greeting-4-out.log',
      error_file: './logs/greeting-4-error.log',
      time: true
    },
    {
      name: 'greeting-generator-5',
      script: './src/core/greetingGenerate.js',
      args: '--process-id=5 --total-processes=8 --batches-per-process=500',
      cwd: '/home/ght/chebichat-project/chebichat-clean-data/qwen/dictionary',
      instances: 1,
      autorestart: false,
      watch: false,
      max_memory_restart: '1G',
      env: {
        NODE_ENV: 'production',
        BATCH_SIZE: 8,
        BATCH_DELAY: 3000
      },
      log_file: './logs/greeting-5-combined.log',
      out_file: './logs/greeting-5-out.log',
      error_file: './logs/greeting-5-error.log',
      time: true
    },
    {
      name: 'greeting-generator-6',
      script: './src/core/greetingGenerate.js',
      args: '--process-id=6 --total-processes=8 --batches-per-process=500',
      cwd: '/home/ght/chebichat-project/chebichat-clean-data/qwen/dictionary',
      instances: 1,
      autorestart: false,
      watch: false,
      max_memory_restart: '1G',
      env: {
        NODE_ENV: 'production',
        BATCH_SIZE: 8,
        BATCH_DELAY: 3000
      },
      log_file: './logs/greeting-6-combined.log',
      out_file: './logs/greeting-6-out.log',
      error_file: './logs/greeting-6-error.log',
      time: true
    },
    {
      name: 'greeting-generator-7',
      script: './src/core/greetingGenerate.js',
      args: '--process-id=7 --total-processes=8 --batches-per-process=500',
      cwd: '/home/ght/chebichat-project/chebichat-clean-data/qwen/dictionary',
      instances: 1,
      autorestart: false,
      watch: false,
      max_memory_restart: '1G',
      env: {
        NODE_ENV: 'production',
        BATCH_SIZE: 8,
        BATCH_DELAY: 3000
      },
      log_file: './logs/greeting-7-combined.log',
      out_file: './logs/greeting-7-out.log',
      error_file: './logs/greeting-7-error.log',
      time: true
    },
    {
      name: 'greeting-generator-8',
      script: './src/core/greetingGenerate.js',
      args: '--process-id=8 --total-processes=8 --batches-per-process=500',
      cwd: '/home/ght/chebichat-project/chebichat-clean-data/qwen/dictionary',
      instances: 1,
      autorestart: false,
      watch: false,
      max_memory_restart: '1G',
      env: {
        NODE_ENV: 'production',
        BATCH_SIZE: 8,
        BATCH_DELAY: 3000
      },
      log_file: './logs/greeting-8-combined.log',
      out_file: './logs/greeting-8-out.log',
      error_file: './logs/greeting-8-error.log',
      time: true
    }
  ]
};
