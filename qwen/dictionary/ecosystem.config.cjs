module.exports = {
  apps: [
    {
      name: 'dict-process-1',
      script: 'dictionaryGenerate.js',
      args: '--process-id=1 --total-processes=10 --batches-per-process=50',
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: '1G',
      cwd: '/home/ght/chebichat-project/chebichat-clean-data/qwen/dictionary',
      env: {
        NODE_ENV: 'production'
      }
    },
    {
      name: 'dict-process-2',
      script: 'dictionaryGenerate.js',
      args: '--process-id=2 --total-processes=10 --batches-per-process=50',
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: '1G',
      cwd: '/home/ght/chebichat-project/chebichat-clean-data/qwen/dictionary',
      env: {
        NODE_ENV: 'production'
      }
    },
    {
      name: 'dict-process-3',
      script: 'dictionaryGenerate.js',
      args: '--process-id=3 --total-processes=10 --batches-per-process=50',
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: '1G',
      cwd: '/home/ght/chebichat-project/chebichat-clean-data/qwen/dictionary',
      env: {
        NODE_ENV: 'production'
      }
    },
    {
      name: 'dict-process-4',
      script: 'dictionaryGenerate.js',
      args: '--process-id=4 --total-processes=10 --batches-per-process=50',
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: '1G',
      cwd: '/home/ght/chebichat-project/chebichat-clean-data/qwen/dictionary',
      env: {
        NODE_ENV: 'production'
      }
    },
    {
      name: 'dict-process-5',
      script: 'dictionaryGenerate.js',
      args: '--process-id=5 --total-processes=10 --batches-per-process=50',
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: '1G',
      cwd: '/home/ght/chebichat-project/chebichat-clean-data/qwen/dictionary',
      env: {
        NODE_ENV: 'production'
      }
    },
    {
      name: 'dict-process-6',
      script: 'dictionaryGenerate.js',
      args: '--process-id=6 --total-processes=10 --batches-per-process=50',
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: '1G',
      cwd: '/home/ght/chebichat-project/chebichat-clean-data/qwen/dictionary',
      env: {
        NODE_ENV: 'production'
      }
    },
    {
      name: 'dict-process-7',
      script: 'dictionaryGenerate.js',
      args: '--process-id=7 --total-processes=10 --batches-per-process=50',
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: '1G',
      cwd: '/home/ght/chebichat-project/chebichat-clean-data/qwen/dictionary',
      env: {
        NODE_ENV: 'production'
      }
    },
    {
      name: 'dict-process-8',
      script: 'dictionaryGenerate.js',
      args: '--process-id=8 --total-processes=10 --batches-per-process=50',
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: '1G',
      cwd: '/home/ght/chebichat-project/chebichat-clean-data/qwen/dictionary',
      env: {
        NODE_ENV: 'production'
      }
    },
    {
      name: 'dict-process-9',
      script: 'dictionaryGenerate.js',
      args: '--process-id=9 --total-processes=10 --batches-per-process=50',
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: '1G',
      cwd: '/home/ght/chebichat-project/chebichat-clean-data/qwen/dictionary',
      env: {
        NODE_ENV: 'production'
      }
    },
    {
      name: 'dict-process-10',
      script: 'dictionaryGenerate.js',
      args: '--process-id=10 --total-processes=10 --batches-per-process=50',
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: '1G',
      cwd: '/home/ght/chebichat-project/chebichat-clean-data/qwen/dictionary',
      env: {
        NODE_ENV: 'production'
      }
    }
  ]
};