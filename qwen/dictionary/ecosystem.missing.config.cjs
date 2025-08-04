module.exports = {
  apps: [
    {
      name: 'missing-items-chunk-1',
      script: 'reprocess_missing_parallel.js',
      args: '--chunk=1',
      instances: 1,
      exec_mode: 'fork',
      env: {
        NODE_ENV: 'production'
      },
      error_file: './logs/chunk-1-error.log',
      out_file: './logs/chunk-1-out.log',
      log_file: './logs/chunk-1-combined.log',
      time: true
    },
    {
      name: 'missing-items-chunk-2',
      script: 'reprocess_missing_parallel.js',
      args: '--chunk=2',
      instances: 1,
      exec_mode: 'fork',
      env: {
        NODE_ENV: 'production'
      },
      error_file: './logs/chunk-2-error.log',
      out_file: './logs/chunk-2-out.log',
      log_file: './logs/chunk-2-combined.log',
      time: true
    },
    {
      name: 'missing-items-chunk-3',
      script: 'reprocess_missing_parallel.js',
      args: '--chunk=3',
      instances: 1,
      exec_mode: 'fork',
      env: {
        NODE_ENV: 'production'
      },
      error_file: './logs/chunk-3-error.log',
      out_file: './logs/chunk-3-out.log',
      log_file: './logs/chunk-3-combined.log',
      time: true
    },
    {
      name: 'missing-items-chunk-4',
      script: 'reprocess_missing_parallel.js',
      args: '--chunk=4',
      instances: 1,
      exec_mode: 'fork',
      env: {
        NODE_ENV: 'production'
      },
      error_file: './logs/chunk-4-error.log',
      out_file: './logs/chunk-4-out.log',
      log_file: './logs/chunk-4-combined.log',
      time: true
    },
    {
      name: 'missing-items-chunk-5',
      script: 'reprocess_missing_parallel.js',
      args: '--chunk=5',
      instances: 1,
      exec_mode: 'fork',
      env: {
        NODE_ENV: 'production'
      },
      error_file: './logs/chunk-5-error.log',
      out_file: './logs/chunk-5-out.log',
      log_file: './logs/chunk-5-combined.log',
      time: true
    }
  ]
};
