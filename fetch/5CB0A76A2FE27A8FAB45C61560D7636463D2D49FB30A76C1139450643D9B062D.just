##
# Builder!
#
# If using builder/buster Docker image, do:
# docker run --rm -v $PWD:/share -it builder/buster /bin/bash
#
# Then:
# just
##



root_dir      := `echo $PWD`



# Build.
@build: _fetch_zephir
	just _info "Building extension."

	/opt/zephir/zephir.phar clean
	/opt/zephir/zephir.phar build



@release: build
	just _info "Packaging extension."

	[ -f "{{ root_dir }}/ext/modules/blobfolio.so" ] || just _error "The extension was not built."

	cp "{{ root_dir }}/ext/modules/blobfolio.so" "{{ root_dir }}/deb/php-blobfolio/usr/lib/php/20180731/blobfolio.so"
	chmod 644 "{{ root_dir }}/deb/php-blobfolio/usr/lib/php/20180731/blobfolio.so"
	chown -R root: "{{ root_dir }}/deb/php-blobfolio/"
	cd "{{ root_dir }}/deb" && dpkg-deb --build php-blobfolio
	chown --reference="{{ root_dir }}/justfile" "{{ root_dir }}/deb/php-blobfolio.deb"

	dpkg -i "{{ root_dir }}/deb/php-blobfolio.deb"
	php -m | grep -i blobfolio || exit 1



@test:
	php -m | grep -i blobfolio || exit 1

	just _info "Unit Tests"

	[ -f "/opt/phpunit" ] || wget -O /opt/phpunit https://phar.phpunit.de/phpunit-8.phar && chmod 755 /opt/phpunit

	cd "{{ root_dir }}" && /opt/phpunit -c "{{ root_dir }}/phpunit.xml.dist"



# Fetch Zephir.
_fetch_zephir:
	#!/usr/bin/env bash

	# We can assume if the Zephir directory exists we're good to go.
	if [ -d "/opt/zephir" ]; then
		exit 0
	fi

	just _info "Installing Zephir and/or PHP."

	mkdir /opt/zephir

	# Make sure PHP is installed.
	apt-get update \
		&& apt-get install -y \
			php7.3-bcmath \
			php7.3-bz2 \
			php7.3-cli \
			php7.3-cli \
			php7.3-common \
			php7.3-curl \
			php7.3-dev \
			php7.3-fpm \
			php7.3-gd \
			php7.3-gmp \
			php7.3-imap \
			php7.3-intl \
			php7.3-json \
			php7.3-mbstring \
			php7.3-mysql \
			php7.3-opcache \
			php7.3-readline \
			php7.3-xml \
			php7.3-zip \
			php-pear \
			php-php-gettext \
			php-phpseclib \
			webp

	# 1.3.1 Zephir Parser
	wget -q -O /opt/zephir/parser.zip "https://github.com/phalcon/php-zephir-parser/archive/v1.3.1.zip"
	cd /opt/zephir && unzip parser.zip && rm parser.zip
	cd php-zephir-parser-1.3.1
	phpize
	./configure
	make
	make install

	echo '[Zephir Parser]' > /etc/php/7.3/mods-available/zephir.ini
	echo 'extension=zephir_parser.so' >> /etc/php/7.3/mods-available/zephir.ini
	ln -s /etc/php/7.3/mods-available/zephir.ini /etc/php/7.3/cli/conf.d/zephir.ini

	# It should be installed!
	php -m | grep -i zephir || exit 1

	# 0.12.1 Zephir
	wget -q -O /opt/zephir/zephir.phar "https://github.com/phalcon/zephir/releases/download/0.12.1/zephir.phar"
	chmod 755 /opt/zephir/zephir.phar

	cd "{{ root_dir }}"
	just _success "Zephir has been installed."



##             ##
# NOTIFICATIONS #
##             ##

# Task header.
@_header TASK:
	echo "\e[34;1m[Task] \e[0;1m{{ TASK }}\e[0m"

# Echo an informational comment.
@_info COMMENT:
	echo "\e[95;1m[Info] \e[0;1m{{ COMMENT }}\e[0m"

# Echo an error.
@_error COMMENT:
	>&2 echo "\e[31;1m[Error] \e[0;1m{{ COMMENT }}\e[0m"

# Echo a success.
@_success COMMENT:
	echo "\e[92;1m[Success] \e[0;1m{{ COMMENT }}\e[0m"
	echo ""
