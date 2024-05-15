ARG POSTGRES_VERSION=14-alpine

#########################################################
# Set the base image to use for subsequent instructions #
#########################################################
FROM postgres:${POSTGRES_VERSION} AS postgres


#########################################################
#          Create a run stage for development           #
#########################################################
FROM postgres AS development-run-stage

# Copy scripts to the container
COPY ./scripts /usr/local/bin/maintenance
# Change line endings of the scripts to Unix format
RUN find /usr/local/bin/maintenance -type f -exec sed -i 's/\r$//' {} \;
# Set execute permission for the maintenance scripts, move them to /usr/local/bin, and remove the maintenance directory
RUN chmod +x /usr/local/bin/maintenance/* \
    && mv /usr/local/bin/maintenance/* /usr/local/bin \
    && rmdir /usr/local/bin/maintenance
