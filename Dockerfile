ARG WORDPRESS_IMAGE

FROM wordpress:${WORDPRESS_IMAGE}

# Installs mhsendmail for Mailhog.
RUN curl --location --output /usr/local/bin/mhsendmail https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 && \
  chmod +x /usr/local/bin/mhsendmail

# Configures sendmail_path and sends to mailhog container.
RUN echo 'sendmail_path="/usr/local/bin/mhsendmail --smtp-addr=mailhog:1025"' > /usr/local/etc/php/conf.d/mailhog.ini
