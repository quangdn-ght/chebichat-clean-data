module.exports = {
  apps: [{
    name: 'province-worker',
    script: './worker.js',
    instances: 4,
    exec_mode: 'cluster',
    env: {
      NODE_ENV: 'production',
      TOTAL_WORKERS: '4',
      BATCH_SIZE: '50',
      UPDATE_DB: 'true'
    },
    error_file: './logs/province-worker-error.log',
    out_file: './logs/province-worker-out.log',
    log_date_format: 'YYYY-MM-DD HH:mm:ss',
    autorestart: false,
    max_memory_restart: '500M',
    time: true
  }]
};
