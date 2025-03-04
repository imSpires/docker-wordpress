FROM wordpress:php8.2-fpm-alpine

WORKDIR /var/www/html

COPY --chown=www-data:www-data . .

RUN apk add --no-cache nginx bash mysql-client

EXPOSE 9000
CMD ["php-fpm"]
