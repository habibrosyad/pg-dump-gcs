#!/bin/sh

# Generate the cron job from the environment variable
echo "${CRON_SCHEDULE} /usr/local/bin/backup.sh > /var/log/cron.log 2>&1" > /etc/crontabs/root

# Start the cron service
crond -f -l 2
