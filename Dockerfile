ARG WORDPRESS_IMAGE

FROM wordpress:${WORDPRESS_IMAGE}

# Installs mhsendmail for Mailhog.
RUN curl --location --output /usr/local/bin/mhsendmail https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 && \
  chmod +x /usr/local/bin/mhsendmail

# Configures sendmail_path and sends to mail container.
RUN echo 'sendmail_path="/usr/local/bin/mhsendmail --smtp-addr=mail:1025"' > /usr/local/etc/php/conf.d/mailhog.ini

# Easy installation of PHP extensions in official PHP Docker images: https://github.com/mlocati/docker-php-extension-installer/.
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

# Install PHP extensions.
RUN chmod +x /usr/local/bin/install-php-extensions && \
  install-php-extensions memcache memcached