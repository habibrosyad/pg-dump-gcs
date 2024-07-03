FROM alpine:latest

# Install necessary packages
RUN apk update && apk add --no-cache \
    bash \
    curl \
    postgresql-client \
    ca-certificates \
    tar \
    python3 \
    py3-pip \
    sed

# Install gsutil
RUN mkdir -p /usr/local/gsutil && \
    curl -o /tmp/gsutil.tar.gz https://storage.googleapis.com/pub/gsutil.tar.gz && \
    tar -xzf /tmp/gsutil.tar.gz -C /usr/local/gsutil && \
    ln -s /usr/local/gsutil/gsutil/gsutil /usr/local/bin/gsutil && \
    rm /tmp/gsutil.tar.gz

# Add the backup script
ADD backup.sh /usr/local/bin/backup.sh
RUN chmod +x /usr/local/bin/backup.sh

# Add the entrypoint script
ADD entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Add boto config file.
ADD boto.cfg /root/.boto
ARG GOOGLE_PROJECT_ID
RUN sed -i "s/your_google_project_id/${GOOGLE_PROJECT_ID}/g" /root/.boto

# Set environment variable for Google credentials
ENV GOOGLE_APPLICATION_CREDENTIALS="/keyfile.json"

# Create a log file for cron jobs
RUN touch /var/log/cron.log && chmod 666 /var/log/cron.log

# Start the cron service through the entrypoint script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
