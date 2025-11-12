module.exports = {
  apps: [
    {
      name: 'attraction-worker',
      script: './worker.js',
      instances: 10,
      exec_mode: 'cluster',
      env: {
        NODE_ENV: 'production',
        TOTAL_WORKERS: 10,
        BATCH_SIZE: 50,
        UPDATE_DB: 'true'
      },
      max_memory_restart: '1G',
      error_file: './logs/pm2-error.log',
      out_file: './logs/pm2-out.log',
      log_date_format: 'YYYY-MM-DD HH:mm:ss',
      merge_logs: true,
      autorestart: false,
      max_restarts: 3,
      min_uptime: '10s'
    }
  ]
};
