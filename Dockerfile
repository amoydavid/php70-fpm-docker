FROM php:7.0-fpm-alpine3.7

MAINTAINER David <t-liu@qq.com>

ENV TIMEZONE=Asia/Shanghai
RUN sed 's/http:\/\/dl-cdn.alpinelinux.org/https:\/\/mirrors.aliyun.com/g' -i /etc/apk/repositories


RUN apk add --no-cache gettext libpng libmcrypt sqlite libxml2 libjpeg-turbo freetype libmemcached zlib && \
    apk add --no-cache --virtual .build-dependencies libxml2-dev sqlite-dev zlib-dev \
    libmcrypt-dev gettext-dev curl-dev freetype-dev libjpeg-turbo-dev libwebp-dev zlib-dev libxpm-dev libpng-dev libmemcached-dev && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ && \
    docker-php-ext-install gettext gd mysqli bcmath exif curl mcrypt mbstring opcache pdo pdo_mysql pdo_sqlite soap session xml xmlrpc zip && \
    curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/4.3.0.tar.gz && \
    tar xfz /tmp/redis.tar.gz && \
    rm -r /tmp/redis.tar.gz && \
    mkdir -p /usr/src/php/ext && \
    mv phpredis-4.3.0 /usr/src/php/ext/redis && \
    docker-php-ext-install redis && \
    curl -L -o /tmp/memcached.tar.gz https://github.com/php-memcached-dev/php-memcached/archive/v3.1.3.tar.gz && \
    tar xfz /tmp/memcached.tar.gz && \
    rm -r /tmp/memcached.tar.gz && \
    mkdir -p /usr/src/php/ext && \
    mv php-memcached-3.1.3 /usr/src/php/ext/memcached && \
    docker-php-ext-install memcached && \
    apk del .build-dependencies 



COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod u+x /docker-entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/bin/env", "php-fpm"]