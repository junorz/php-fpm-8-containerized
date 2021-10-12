FROM php:8-fpm

ENV MYSQLD_SOCK=/var/run/mysqld/mysqld.sock

RUN apt update && \
apt install -y libbz2-dev \
libfreetype6-dev libjpeg62-turbo-dev libpng-dev \
libxml2-dev libtidy-dev libxslt1-dev \
libpq-dev \
libmcrypt-dev \
libmagickwand-dev && \
pecl install mcrypt && \
pecl install imagick && \
pecl install redis && \
docker-php-ext-configure gd --with-freetype --with-jpeg && \
docker-php-ext-configure opcache --enable-opcache && \
docker-php-ext-install -j$(nproc) pdo_mysql mysqli pgsql pdo_pgsql bz2 gd soap tidy xsl opcache && \
docker-php-ext-enable mcrypt imagick redis

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

RUN echo "opcache.enable=1" >> "$PHP_INI_DIR/php.ini" && \
echo "opcache.memory_consumption=128" >> "$PHP_INI_DIR/php.ini" && \
echo "opcache.interned_strings_buffer=8" >> "$PHP_INI_DIR/php.ini" && \
echo "opcache.max_accelerated_files=4000" >> "$PHP_INI_DIR/php.ini" && \
echo "opcache.revalidate_freq=60" >> "$PHP_INI_DIR/php.ini" && \
echo "opcache.enable_cli=1" >> "$PHP_INI_DIR/php.ini" && \
echo "opcache.jit=tracing" >> "$PHP_INI_DIR/php.ini" && \
echo "opcache.jit_buffer_size=128M" >> "$PHP_INI_DIR/php.ini"

RUN sed -i "s|pdo_mysql.default_socket=|pdo_mysql.default_socket=$MYSQLD_SOCK|" "$PHP_INI_DIR/php.ini" && \
sed -i "s|mysqli.default_socket =|mysqli.default_socket =$MYSQLD_SOCK|" "$PHP_INI_DIR/php.ini"

