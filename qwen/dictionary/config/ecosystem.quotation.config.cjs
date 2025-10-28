module.exports = {
  apps: [
    {
      name: 'quotation-process-1',
      script: './src/core/quotationGenerate.js',
      args: '--process-id=1 --total-processes=8 --batches-per-process=100',
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: '1G',
      cwd: '/home/ght/chebichat-project/chebichat-clean-data/qwen/dictionary',
      env: {
        NODE_ENV: 'production',
        BATCH_SIZE: '10',
        BATCH_DELAY: '1500'
      }
    },
    {
      name: 'quotation-process-2',
      script: './src/core/quotationGenerate.js',
      args: '--process-id=2 --total-processes=8 --batches-per-process=100',
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: '1G',
      cwd: '/home/ght/chebichat-project/chebichat-clean-data/qwen/dictionary',
      env: {
        NODE_ENV: 'production',
        BATCH_SIZE: '10',
        BATCH_DELAY: '1500'
      }
    },
    {
      name: 'quotation-process-3',
      script: './src/core/quotationGenerate.js',
      args: '--process-id=3 --total-processes=8 --batches-per-process=100',
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: '1G',
      cwd: '/home/ght/chebichat-project/chebichat-clean-data/qwen/dictionary',
      env: {
        NODE_ENV: 'production',
        BATCH_SIZE: '10',
        BATCH_DELAY: '1500'
      }
    },
    {
      name: 'quotation-process-4',
      script: './src/core/quotationGenerate.js',
      args: '--process-id=4 --total-processes=8 --batches-per-process=100',
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: '1G',
      cwd: '/home/ght/chebichat-project/chebichat-clean-data/qwen/dictionary',
      env: {
        NODE_ENV: 'production',
        BATCH_SIZE: '10',
        BATCH_DELAY: '1500'
      }
    },
    {
      name: 'quotation-process-5',
      script: './src/core/quotationGenerate.js',
      args: '--process-id=5 --total-processes=8 --batches-per-process=100',
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: '1G',
      cwd: '/home/ght/chebichat-project/chebichat-clean-data/qwen/dictionary',
      env: {
        NODE_ENV: 'production',
        BATCH_SIZE: '10',
        BATCH_DELAY: '1500'
      }
    },
    {
      name: 'quotation-process-6',
      script: './src/core/quotationGenerate.js',
      args: '--process-id=6 --total-processes=8 --batches-per-process=100',
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: '1G',
      cwd: '/home/ght/chebichat-project/chebichat-clean-data/qwen/dictionary',
      env: {
        NODE_ENV: 'production',
        BATCH_SIZE: '10',
        BATCH_DELAY: '1500'
      }
    },
    {
      name: 'quotation-process-7',
      script: './src/core/quotationGenerate.js',
      args: '--process-id=7 --total-processes=8 --batches-per-process=100',
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: '1G',
      cwd: '/home/ght/chebichat-project/chebichat-clean-data/qwen/dictionary',
      env: {
        NODE_ENV: 'production',
        BATCH_SIZE: '10',
        BATCH_DELAY: '1500'
      }
    },
    {
      name: 'quotation-process-8',
      script: './src/core/quotationGenerate.js',
      args: '--process-id=8 --total-processes=8 --batches-per-process=100',
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: '1G',
      cwd: '/home/ght/chebichat-project/chebichat-clean-data/qwen/dictionary',
      env: {
        NODE_ENV: 'production',
        BATCH_SIZE: '10',
        BATCH_DELAY: '1500'
      }
    }
  ]
};
