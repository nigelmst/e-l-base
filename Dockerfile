FROM php:8.0.14-fpm-alpine

RUN echo "http://dl-cdn.alpinelinux.org/alpine/latest-stable/main" >> /etc/apk/repositories
ARG APK_COMMON_DEPENDENCIES="bash busybox-suid curl dcron git libcap mysql-client unzip zip"
RUN apk add --update --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/latest-stable/main $APK_COMMON_DEPENDENCIES

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/
ARG PHP_EXTENSIONS="bcmath exif gd gmp imagick intl maxminddb opcache pcntl pdo_mysql sockets zip"
RUN install-php-extensions $PHP_EXTENSIONS

ENV NON_ROOT_GROUP=${NON_ROOT_GROUP:-app}
ENV NON_ROOT_USER=${NON_ROOT_USER:-app}
RUN addgroup -S $NON_ROOT_GROUP && adduser -S $NON_ROOT_USER -G $NON_ROOT_GROUP
RUN addgroup $NON_ROOT_USER wheel
