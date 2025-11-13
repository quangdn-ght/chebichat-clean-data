module.exports = {
  apps: [{
    name: 'region-worker',
    script: './worker.js',
    instances: 10,
    exec_mode: 'cluster',
    env: {
      NODE_ENV: 'production',
      TOTAL_WORKERS: '10',
      BATCH_SIZE: '50',
      UPDATE_DB: 'true'
    },
    error_file: './logs/region-worker-error.log',
    out_file: './logs/region-worker-out.log',
    log_date_format: 'YYYY-MM-DD HH:mm:ss',
    autorestart: false,
    max_memory_restart: '500M',
    time: true
  }]
};
