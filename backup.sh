#!/bin/sh

# Log the start of the script
echo "$(date) - Starting backup script" >> /var/log/cron.log

# Variables
DB_HOST="your_postgres_container"  # This should be the service name from docker-compose.yml
DB_NAME="your_database_name"
DB_USER="your_database_user"
DB_PASSWORD="your_database_password"
BACKUP_FILE="/backup/$(date +%Y%m%d%H%M%S)_${DB_NAME}.sql"
GCS_BUCKET="your-gcs-bucket"
GOOGLE_APPLICATION_CREDENTIALS="/keyfile.json"

# Export password so pg_dump can use it
export PGPASSWORD=$DB_PASSWORD

# Dump the PostgreSQL database
pg_dump -h $DB_HOST -U $DB_USER -d $DB_NAME > $BACKUP_FILE

# Check if pg_dump succeeded
if [ $? -eq 0 ]; then
    echo "$(date) - Database dump successful" >> /var/log/cron.log
else
    echo "$(date) - Database dump failed" >> /var/log/cron.log
    exit 1
fi

# Use gsutil to upload the backup to GCS
gsutil cp $BACKUP_FILE gs://$GCS_BUCKET/

# Check if gsutil succeeded
if [ $? -eq 0 ]; then
    echo "$(date) - Upload to GCS successful" >> /var/log/cron.log
else
    echo "$(date) - Upload to GCS failed" >> /var/log/cron.log
    exit 1
fi

# Remove the local backup file
rm $BACKUP_FILE

# Log the end of the script
echo "$(date) - Backup script completed" >> /var/log/cron.log
