FROM php:7.1-apache

ENV DEBIAN_FRONTEND=noninteractive \
	TZ=Asia/Seoul \
	COMPOSER_ALLOW_SUPERUSER=1 \
	COMPOSER_HOME=/composer \
	PATH=$PATH:/composer/vendor/bin

# ✅ 1. 오래된 Debian 저장소 URL 교체 (필수)
RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list && \
	sed -i '/security.debian.org/d' /etc/apt/sources.list

# ✅ 2. 필수 패키지 설치 + PHP 확장 설치
RUN apt update && apt install -y --no-install-recommends \
	curl \
	unzip \
	git \
	ca-certificates \
	cron \
	gnupg \
	supervisor \
	libpng-dev \
	libzip-dev \
	libxml2-dev \
	libtool \
	build-essential \
	autoconf \
	&& docker-php-ext-install pdo pdo_mysql zip gd

# ✅ 3. libmcrypt 소스 설치 (필수)
RUN curl -fsSL http://downloads.sourceforge.net/project/mcrypt/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz | tar zx && \
	cd libmcrypt-2.5.8 && \
	./configure && \
	make && \
	make install && \
	ldconfig && \
	cd .. && \
	rm -rf libmcrypt-2.5.8

# ✅ 4. PECL을 통해 mcrypt 확장 설치
# RUN pecl install mcrypt-1.0.1 && docker-php-ext-enable mcrypt

# ✅ 5. Apache 설정
COPY docker/files/laravel.conf /etc/apache2/sites-available/laravel.conf
RUN a2dissite 000-default && \
	a2ensite laravel && \
	a2enmod rewrite headers

# ✅ 6. Composer 설치
RUN curl -sS https://getcomposer.org/installer | php && \
	mv composer.phar /usr/local/bin/composer

# ✅ 7. 워크디렉터리 설정
WORKDIR /app

EXPOSE 80
