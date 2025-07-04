# List all processes
pm2 list

# View logs
pm2 logs dictionary-generator

# Stop the process
pm2 stop dictionary-generator

# Restart the process
pm2 restart dictionary-generator

# Delete the process
pm2 delete dictionary-generator

# Monitor processes (real-time dashboard)
pm2 monit

# Save current process list
pm2 save

# Auto-start processes on system reboot
pm2 startup