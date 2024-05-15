#!/usr/bin/env sh

# Constants with default values
: "${PROJECT_NAME:=config}"
: "${SERVER_PORT:=8000}"
: "${WORK_DIRECTORY:=/app}"
: "${APPS_DIRECTORY:=${WORK_DIRECTORY}/apps}"
: "${STATICFILES_DIRECTORY:=/assets/static}"
: "${MEDIAFILES_DIRECTORY:=/assets/media}"
