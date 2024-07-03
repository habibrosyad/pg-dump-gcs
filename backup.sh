#!/bin/sh

# Ensure environment variables are exported
export DB_HOST=${DB_HOST}
export DB_NAME=${DB_NAME}
export DB_USER=${DB_USER}
export DB_PASSWORD=${DB_PASSWORD}
export GCS_BUCKET=${GCS_BUCKET}
export GOOGLE_APPLICATION_CREDENTIALS=${GOOGLE_APPLICATION_CREDENTIALS}

# Log the start of the script
echo "$(date) - Starting backup script" | tee -a /var/log/cron.log

# Variables
BACKUP_FILE="/backup/$(date +%Y%m%d%H%M%S)_${DB_NAME}.sql"

# Export password so pg_dump can use it
export PGPASSWORD=$DB_PASSWORD

# Dump the PostgreSQL database
pg_dump -h $DB_HOST -U $DB_USER -d $DB_NAME > $BACKUP_FILE

# Check if pg_dump succeeded
if [ $? -eq 0 ]; then
    echo "$(date) - Database dump successful" | tee -a /var/log/cron.log
else
    echo "$(date) - Database dump failed" | tee -a /var/log/cron.log
    exit 1
fi

# Use gsutil to upload the backup to GCS
gsutil cp $BACKUP_FILE gs://$GCS_BUCKET/

# Check if gsutil succeeded
if [ $? -eq 0 ]; then
    echo "$(date) - Upload to GCS successful" | tee -a /var/log/cron.log
else
    echo "$(date) - Upload to GCS failed" | tee -a /var/log/cron.log
    exit 1
fi

# Remove the local backup file
rm $BACKUP_FILE

# Log the end of the script
echo "$(date) - Backup script completed" | tee -a /var/log/cron.log
