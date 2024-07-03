#!/bin/sh

# Print the current crontab for debugging purposes
echo "Setting up cron job with schedule: ${CRON_SCHEDULE}"
echo "${CRON_SCHEDULE} /usr/local/bin/backup.sh > /var/log/cron.log 2>&1" > /etc/crontabs/root
crontab -l

# Start the cron service in the foreground
echo "Starting cron service..."
crond -f -l 2
