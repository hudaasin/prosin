ARG PYTHON_VERSION=3.12-alpine

#########################################################
# Set the base image to use for subsequent instructions #
#########################################################
FROM python:${PYTHON_VERSION} AS python


#########################################################
#     Create a build stage for Python dependencies      #
#########################################################
FROM python AS python-build-stage

# Set the build environment variable
ARG BUILD_ENVIRONMENT=development

# Install necessary packages for building and running the program
RUN apk update && apk add --no-cache \
    # Add build-base for building Python packages
    build-base \
    # Add postgresql-dev for PostgreSQL development libraries
    postgresql-dev 

# Copy the requirements file
COPY ./requirements .

# Convert requirements to wheels
RUN pip wheel --wheel-dir /usr/src/app/wheels \
    -r ${BUILD_ENVIRONMENT}.txt


#########################################################
#    Create a run stage for the Python application      #
#########################################################
FROM python AS development-run-stage

# Set the build environment and app home directory
ARG WORK_DIRECTORY=/app

# Set environment variables to prevent Python from writing pyc files and to ensure that Python output is unbuffered
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set the PYTHONPATH environment variable to include ${WORK_DIRECTORY}
ENV PYTHONPATH=${WORK_DIRECTORY}:$PYTHONPATH

# Set the working directory
WORKDIR ${WORK_DIRECTORY}

# Install additional packages and remove cache
RUN apk update && \
    apk add --no-cache libpq gettext && \
    rm -rf /var/cache/apk/*

# Copy Python dependencies from the build stage
COPY --from=python-build-stage /usr/src/app/wheels /wheels/

# Install Python dependencies and remove wheel files
RUN pip install --no-cache-dir --no-index --find-links=/wheels/ /wheels/* \
    && rm -rf /wheels/

# Copy maintenance scripts
COPY ./docker/django/scripts /usr/local/bin/maintenance
# Change line endings of the scripts to Unix format
RUN find /usr/local/bin/maintenance -type f -exec sed -i 's/\r$//' {} \;
# Set permissions
RUN chmod +x /usr/local/bin/maintenance/*
RUN mv /usr/local/bin/maintenance/* /usr/local/bin \
    && rmdir /usr/local/bin/maintenance

# Copy application code
COPY . ${WORK_DIRECTORY}

# Set the entrypoint for the container
ENTRYPOINT [ "entrypoint" ]
