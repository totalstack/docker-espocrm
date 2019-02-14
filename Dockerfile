FROM ubuntu:16.04

MAINTAINER John Paul Iglesia

ARG TZ="Asia/Manila"
ARG ESPO_VERSION=5.5.6

ENV PROJECT_PATH=/var/www/html \
    PROJECT_URL=audioslug.my.to \
    APACHE_RUN_USER=www-data \
    APACHE_RUN_GROUP=www-data \
    APACHE_LOG_DIR=/var/log/apache2 \
    APACHE_PID_FILE=/var/run/apache2/apache2.pid \
    APACHE_LOCK_DIR=/var/lock/apache2 \
    PHP_MODS_CONF=/etc/php/7.0/mods-available \
    PHP_INI=/etc/php/7.0/apache2/php.ini \
    TERM=xterm

# Install Apache, PHP and supplementary programs
RUN apt-get update -qq && apt-get install -yqq --no-install-recommends apt-utils
RUN DEBIAN_FRONTEND=noninteractive apt-get install -yqq apache2 \
    wget \
    nano \
    php \
    curl \
    zip \
    sudo \
    cron \
    libapache2-mod-php \
    php-mcrypt \
    php-mysql \
    php-zip \
    php-curl \
    php-mbstring \
    php-imap \
    php-gd \
    php-gettext

# Enable Apache Modules
RUN a2enmod rewrite
RUN a2enmod proxy
RUN a2enmod proxy_http
RUN a2enmod headers

# Enable PHP Modules
RUN phpenmod mcrypt
RUN phpenmod mbstring
RUN phpenmod imap

# Modify PHP Configuration
RUN sed -i "s,^max_execution_time =.*$,max_execution_time = 180," $PHP_INI && \
    sed -i "s,^max_input_time =.*$,max_input_time = 180M," $PHP_INI && \
    sed -i "s,^memory_limit =.*$,memory_limit = 256M," $PHP_INI && \
    sed -i "s,^post_max_size =.*$,post_max_size = 100M," $PHP_INI && \
    sed -i "s,^upload_max_filesize =.*$,upload_max_filesize = 100M," $PHP_INI


# Set the timezone
RUN sudo echo $TZ > /etc/timezone \
    sudo dpkg-reconfigure -f noninteractive tzdata

# Add our crontab file
ADD crontab /etc/cron.d/espo-cron

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/espo-cron

# Virtualhost
COPY site.conf /etc/apache2/sites-available/000-default.conf 

# Clean the Project Path
RUN rm -rf $PROJECT_PATH

# Download ESPOCRM
WORKDIR $PROJECT_PATH
RUN wget --no-check-certificate https://www.espocrm.com/downloads/EspoCRM-$ESPO_VERSION.zip && \
    unzip EspoCRM-$ESPO_VERSION.zip -d /var/www/html
RUN mv /var/www/html/EspoCRM-$ESPO_VERSION/* /var/www/html/

# Modify Project Path Ownership
RUN chown -R $APACHE_RUN_USER:$APACHE_RUN_GROUP $PROJECT_PATH

# Port to expose
EXPOSE 80

# Apply cron job
RUN crontab /etc/cron.d/espo-cron

# Remove pre-existent apache pid and start apache
CMD rm -f $APACHE_PID_FILE && cron
CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"]

