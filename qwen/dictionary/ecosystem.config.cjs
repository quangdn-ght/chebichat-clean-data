module.exports = {
  apps: [
    {
      name: 'dict-process-1',
      script: 'dictionaryGenerate.js',
      args: '--process-id=1 --total-processes=30 --batches-per-process=164',
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
      args: '--process-id=2 --total-processes=30 --batches-per-process=164',
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
      args: '--process-id=3 --total-processes=30 --batches-per-process=164',
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
      args: '--process-id=4 --total-processes=30 --batches-per-process=164',
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
      args: '--process-id=5 --total-processes=30 --batches-per-process=164',
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
      args: '--process-id=6 --total-processes=30 --batches-per-process=164',
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
      args: '--process-id=7 --total-processes=30 --batches-per-process=164',
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
      args: '--process-id=8 --total-processes=30 --batches-per-process=164',
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
      args: '--process-id=9 --total-processes=30 --batches-per-process=164',
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
      args: '--process-id=10 --total-processes=30 --batches-per-process=164',
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
      name: 'dict-process-11',
      script: 'dictionaryGenerate.js',
      args: '--process-id=11 --total-processes=30 --batches-per-process=164',
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
      name: 'dict-process-12',
      script: 'dictionaryGenerate.js',
      args: '--process-id=12 --total-processes=30 --batches-per-process=164',
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
      name: 'dict-process-13',
      script: 'dictionaryGenerate.js',
      args: '--process-id=13 --total-processes=30 --batches-per-process=164',
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
      name: 'dict-process-14',
      script: 'dictionaryGenerate.js',
      args: '--process-id=14 --total-processes=30 --batches-per-process=164',
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
      name: 'dict-process-15',
      script: 'dictionaryGenerate.js',
      args: '--process-id=15 --total-processes=30 --batches-per-process=164',
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
      name: 'dict-process-16',
      script: 'dictionaryGenerate.js',
      args: '--process-id=16 --total-processes=30 --batches-per-process=164',
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
      name: 'dict-process-17',
      script: 'dictionaryGenerate.js',
      args: '--process-id=17 --total-processes=30 --batches-per-process=164',
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
      name: 'dict-process-18',
      script: 'dictionaryGenerate.js',
      args: '--process-id=18 --total-processes=30 --batches-per-process=164',
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
      name: 'dict-process-19',
      script: 'dictionaryGenerate.js',
      args: '--process-id=19 --total-processes=30 --batches-per-process=164',
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
      name: 'dict-process-20',
      script: 'dictionaryGenerate.js',
      args: '--process-id=20 --total-processes=30 --batches-per-process=164',
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
      name: 'dict-process-21',
      script: 'dictionaryGenerate.js',
      args: '--process-id=21 --total-processes=30 --batches-per-process=164',
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
      name: 'dict-process-22',
      script: 'dictionaryGenerate.js',
      args: '--process-id=22 --total-processes=30 --batches-per-process=164',
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
      name: 'dict-process-23',
      script: 'dictionaryGenerate.js',
      args: '--process-id=23 --total-processes=30 --batches-per-process=164',
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
      name: 'dict-process-24',
      script: 'dictionaryGenerate.js',
      args: '--process-id=24 --total-processes=30 --batches-per-process=164',
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
      name: 'dict-process-25',
      script: 'dictionaryGenerate.js',
      args: '--process-id=25 --total-processes=30 --batches-per-process=164',
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
      name: 'dict-process-26',
      script: 'dictionaryGenerate.js',
      args: '--process-id=26 --total-processes=30 --batches-per-process=164',
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
      name: 'dict-process-27',
      script: 'dictionaryGenerate.js',
      args: '--process-id=27 --total-processes=30 --batches-per-process=164',
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
      name: 'dict-process-28',
      script: 'dictionaryGenerate.js',
      args: '--process-id=28 --total-processes=30 --batches-per-process=164',
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
      name: 'dict-process-29',
      script: 'dictionaryGenerate.js',
      args: '--process-id=29 --total-processes=30 --batches-per-process=164',
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
      name: 'dict-process-30',
      script: 'dictionaryGenerate.js',
      args: '--process-id=30 --total-processes=30 --batches-per-process=164',
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