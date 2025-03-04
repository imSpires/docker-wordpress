# Use a lightweight PHP-FPM Alpine base image
FROM php:8.2-fpm-alpine

# Install dependencies for WordPress
RUN apk add --no-cache \
    nginx \
    mariadb-client \
    && docker-php-ext-install mysqli pdo pdo_mysql \
    && rm -rf /var/cache/apk/*

# Set working directory
WORKDIR /var/www/html

# Download and extract WordPress
RUN wget -O /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz \
    && tar -xzf /tmp/wordpress.tar.gz -C /var/www/html --strip-components=1 \
    && rm /tmp/wordpress.tar.gz \
    && chown -R www-data:www-data /var/www/html

# Copy custom Nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Use a non-root user
USER www-data

# Expose port
EXPOSE 80

# Start PHP-FPM and Nginx
CMD ["sh", "-c", "php-fpm -D && nginx -g 'daemon off;'"]