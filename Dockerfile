FROM php:fpm-alpine

COPY docker-entrypoint.sh php.ini default.conf /
RUN apk add --no-cache \
        git \
        bash \
        nginx \
        tzdata \
        openssl \
        openssh && \
    mkdir -p /run/nginx && \
    mv /default.conf /etc/nginx/conf.d && \
    mv /php.ini /usr/local/etc/php && \
    chmod +x /docker-entrypoint.sh && \
    mkdir /var/www/html/config /var/www/html/cache && \
    ssh-keygen -A

# Persistent config file and cache
VOLUME [ "/var/www/html/config", "/var/www/html/cache" ]
ENTRYPOINT [ "/docker-entrypoint.sh" ]
