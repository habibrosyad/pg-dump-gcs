# PostgreSQL Backup to Google Cloud Storage

This repository provides a solution to back up a PostgreSQL database to Google Cloud Storage (GCS) using Docker and Docker Compose. The backups are scheduled using cron jobs, and the configuration allows for flexible scheduling via environment variables.

## Introduction

This project aims to automate the backup process for PostgreSQL databases, ensuring that backups are regularly created and securely stored in Google Cloud Storage. The solution leverages Docker containers to isolate the backup process and ensure compatibility across different environments.

## Prerequisites

- Docker
- Docker Compose
- Google Cloud SDK installed on the host (for initial setup)
- A Google Cloud service account with the necessary permissions to write to your GCS bucket

## Getting Started

### 1. Clone the Repository

```sh
git clone https://github.com/habibrosyad/pg-dump-gcs.git
cd pg-dump-gcs
```

### 2. Set Up Google Cloud Credentials
Create a service account in your Google Cloud project.
Download the JSON key file for the service account.
Place the JSON key file in the root directory of the repository and name it `keyfile.json`.

### 3. Configure Environment Variables
Edit the docker-compose.yml file to set your PostgreSQL and GCS configurations:

```yaml
version: '3.8'
services:
  postgres:
    image: postgres:latest
    container_name: your_postgres_container
    environment:
      POSTGRES_DB: your_database_name
      POSTGRES_USER: your_database_user
      POSTGRES_PASSWORD: your_database_password
    volumes:
      - postgres_data:/var/lib/postgresql/data  # Persist PostgreSQL data

  backup:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: postgres_backup
    volumes:
      - ./backup:/backup  # Store backups on the host
    environment:
      - DB_HOST=your_postgres_container
      - DB_NAME=your_database_name
      - DB_USER=your_database_user
      - DB_PASSWORD=your_database_password
      - GCS_BUCKET=your-gcs-bucket
      - CRON_SCHEDULE=0 0 * * *   # Modify this value as needed
    depends_on:
      - postgres

volumes:
  postgres_data:

```

### 4. Build and Run the Containers
Build the Docker images:

```sh
docker-compose build
```

Run the Docker containers:

```sh
docker-compose up -d
```

### 5. Verify Backup
Check the logs to verify that the backup is running as expected:

```sh
docker logs postgres_backup
```

Backups will be stored in the specified GCS bucket. The backup files will be named with the current date and time to ensure uniqueness.

## Customizing the Cron Schedule

The cron schedule can be customized via the CRON_SCHEDULE environment variable in the docker-compose.yml file. The format follows standard cron syntax:

```sh
CRON_SCHEDULE="0 0 * * *"  # Default: daily at midnight
```

Adjust this value to set your desired backup frequency.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contributions

Contributions are welcome! Please feel free to submit a Pull Request or open an Issue.
