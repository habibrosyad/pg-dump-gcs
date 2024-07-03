#!/bin/sh

# Variables
DB_HOST="your_postgres_host"  # This should be the service name from docker-compose.yml or other postgres instance host
DB_NAME="your_database_name"
DB_USER="your_database_user"
DB_PASSWORD="your_database_password"
BACKUP_FILE="/backup/$(date +%Y%m%d%H%M%S)_${DB_NAME}.sql"
GCS_BUCKET="your-gcs-bucket"
GOOGLE_APPLICATION_CREDENTIALS="/root/.gcloud/keyfile.json"

# Export password so pg_dump can use it
export PGPASSWORD=$DB_PASSWORD

# Dump the PostgreSQL database
pg_dump -h $DB_HOST -U $DB_USER -d $DB_NAME > $BACKUP_FILE

# Upload the backup to GCS
/usr/local/bin/gsutil cp $BACKUP_FILE gs://$GCS_BUCKET/

# Remove the local backup file
rm $BACKUP_FILE
