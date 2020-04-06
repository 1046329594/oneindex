FROM php:fpm-alpine
ENV HOME /root
COPY docker-entrypoint.sh php.ini default.conf /
COPY oneindex3/* /var/www/html/
RUN apk add --no-cache \
        bash \
        nginx \
        tzdata \
        openssl && \
    mkdir -p /run/nginx && \
    mv /default.conf /etc/nginx/conf.d && \
    mv /php.ini /usr/local/etc/php && \
    chmod +x /docker-entrypoint.sh
ENTRYPOINT [ "/docker-entrypoint.sh" ]
