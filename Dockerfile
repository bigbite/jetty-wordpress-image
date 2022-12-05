ARG WORDPRESS_IMAGE

FROM wordpress:${WORDPRESS_IMAGE}

# Install Mailpit.
RUN ["/bin/bash", "-c", "bash < <(curl -sL https://raw.githubusercontent.com/axllent/mailpit/develop/install.sh)"]

# Configure sendmail to use Mailpit.
RUN echo 'sendmail_path="/usr/local/bin/mailpit sendmail --smtp-addr=mail:1025"' > /usr/local/etc/php/conf.d/mail.ini

# Easy installation of PHP extensions in official PHP Docker images: https://github.com/mlocati/docker-php-extension-installer/.
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

# Install PHP extensions.
RUN chmod +x /usr/local/bin/install-php-extensions && \
  install-php-extensions memcache memcached xdebug