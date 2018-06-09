FROM sylius/nginx-php-fpm:latest
MAINTAINER Sylius Docker Team <docker@sylius.org>

ARG AS_UID=1000

ENV SYLIUS_VERSION 1.1.1

ENV BASE_DIR /var/www
ENV SYLIUS_DIR ${BASE_DIR}/sylius

#Modify UID of www-data into UID of local user
RUN usermod -u ${AS_UID} www-data

# Operate as www-data in SYLIUS_DIR per default
WORKDIR ${BASE_DIR}

# Create Sylius project
# USER www-data
# RUN composer create-project \
# 		sylius/sylius-standard \
# 		${SYLIUS_DIR} \
# 		${SYLIUS_VERSION} \
# 	&& chmod +x sylius/bin/console \
# 	# Patch Sylius Standard from master (required for version < 1.1) \
# 	&& cd sylius \
# 	&& rm -f app/config/parameters.yml \
# 	&& curl -o app/config/parameters.yml.dist https://raw.githubusercontent.com/Sylius/Sylius-Standard/master/app/config/parameters.yml.dist \
# 	&& composer run-script post-install-cmd
USER root

#Get PHP GD working for the project
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libfreetype6-dev \
    libjpeg-dev \
    libxpm-dev \
    libxml2-dev \
    libxslt-dev \
    libmcrypt-dev \
    libwebp-dev  # php >=7.0 (use libvpx for php <7.0)
RUN docker-php-ext-configure gd \
    --with-freetype-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ \
    --with-xpm-dir=/usr/include \
    --with-webp-dir=/usr/include/ # php >=7.0 (use libvpx for php <7.0)
RUN docker-php-ext-install gd

# entrypoint.d scripts
COPY entrypoint.d/* /entrypoint.d/

# nginx configuration
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/sylius_params /etc/nginx/sylius_params

RUN chown www-data:www-data /etc/nginx/sylius_params
