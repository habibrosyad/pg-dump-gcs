#!/bin/sh

# Log the entrypoint start
echo "$(date) - Entrypoint script started" | tee -a /var/log/cron.log

# Generate the cron job from the environment variable
echo "Setting up cron job with schedule: ${CRON_SCHEDULE}"
echo "${CRON_SCHEDULE} /usr/local/bin/backup.sh >> /var/log/cron.log 2>&1" > /etc/crontabs/root
crontab -l

# Run the backup script immediately
echo "Running the backup script for the first time..."
/usr/local/bin/backup.sh | tee -a /var/log/cron.log 2>&1

# Start the cron service in the foreground
echo "Starting cron service..."
crond -f -l 2
