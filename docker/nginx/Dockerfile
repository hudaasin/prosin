ARG NGINX_VERSION=1.25-alpine

#########################################################
# Set the base image to use for subsequent instructions #
#########################################################
FROM nginx:${NGINX_VERSION} AS nginx


#########################################################
#          Create a run stage for development           #
#########################################################
FROM nginx AS development-run-stage

# Remove the default configuration file /etc/nginx/conf.d/default.conf.
RUN rm /etc/nginx/conf.d/default.conf

# Copy the default.dev.conf configuration file to the /etc/nginx/conf.d/default.conf path inside the image.
COPY ./confs/default.dev.conf /etc/nginx/conf.d/default.conf
