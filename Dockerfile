FROM php:8.2-fpm-alpine
RUN apk add --no-cache nginx mariadb-client wget ca-certificates \
    && docker-php-ext-install mysqli pdo pdo_mysql \
    && rm -rf /var/cache/apk/*
WORKDIR /var/www/html
RUN wget --retry-connrefused --tries=3 -O /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz \
    && tar -xzf /tmp/wordpress.tar.gz -C /var/www/html --strip-components=1 \
    && rm /tmp/wordpress.tar.gz \
    && mkdir -p /var/www/html/tmp \
    && chown -R www-data:www-data /var/www/html \
    && rm -f /etc/nginx/conf.d/*  # Remove default configs
    && nginx -t  # Verify config
COPY nginx.conf /etc/nginx/nginx.conf
USER www-data
EXPOSE 80
CMD ["sh", "-c", "php-fpm -D && nginx -g 'daemon off;'"]
