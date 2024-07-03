FROM alpine:latest

# Install necessary packages
RUN apk update && apk add --no-cache \
    bash \
    curl \
    python3 \
    py3-pip \
    postgresql-client \
    openrc \
    && pip3 install --upgrade pip \
    && pip3 install google-cloud-storage

# Install Google Cloud SDK
RUN curl -sSL https://sdk.cloud.google.com | bash

# Add the backup script
ADD backup.sh /usr/local/bin/backup.sh
RUN chmod +x /usr/local/bin/backup.sh

# Add the entrypoint script
ADD entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set environment variable for Google credentials
ENV GOOGLE_APPLICATION_CREDENTIALS="/keyfile.json"

# Create a log file for cron jobs
RUN touch /var/log/cron.log

# Start the cron service through the entrypoint script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
