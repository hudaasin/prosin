#!/usr/bin/env bash

# Set the backup source
BACKUP_SOURCE="/var/lib/postgresql/data" # Set the source directory for the backup
BACKUP_DESTINATION="${BACKUP_SOURCE}"    # Set the destination directory for the backup (same as source in this case)

# Set the backup directory path
DBMS_BACKUP_DIR='/backups'
DATA_BACKUP_DIR="$DBMS_BACKUP_DIR"

# Set the backup file prefix
DBMS_BACKUP_FILE_PREFIX='postgres' # Prefix for backup files containing data specifically from the database service, focusing on DBMS backups
DATA_BACKUP_FILE_PREFIX='database' # Prefix for backup files containing data from database services, focusing on individual database backups

# Set the backup file suffix
DBMS_BACKUP_FILE_SUFFIX="dbms" # Suffix for backup files containing data specifically from the database service, focusing on DBMS backups
DATA_BACKUP_FILE_SUFFIX='data' # Suffix for backup files containing data from database services, focusing on individual database backups

# Define a pattern to match the database backup file name and extract the full database name
DATA_BACKUP_PATTERN="^([^_]+_db)_.*_data.sql.gz$"
