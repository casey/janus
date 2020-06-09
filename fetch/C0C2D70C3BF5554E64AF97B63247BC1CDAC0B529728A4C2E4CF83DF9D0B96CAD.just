##
# Build Tasks
#
# This requires "just" >= 0.5.4.
# See https://github.com/casey/just for more details.
#
# USAGE:
#   just --list
#   just <task>
#
# It is recommended to use the provided Docker environment for all your
# build-related needs as it will keep Composer, PHPCS, PHPUnit, etc.,
# off your local machine.
#
# To do that, type:
#   just docker-launch
#
# Then from within the Docker session, run the task you want, e.g.:
#   just watch
##

bin_dir      := justfile_directory() + "/bin"
build_dir    := justfile_directory() + "/_"
lib_dir      := justfile_directory() + "/lib"
skel_dir     := justfile_directory() + "/skel"
test_dir     := justfile_directory() + "/tests"
vendor_dir   := lib_dir + "/vendor"



##        ##
# RAW DATA #
##        ##

# Build data.
@data: _requirements
	just _header "Building Data."

	# Make sure we have a place to shove our raw data.
	[ -d "/tmp/raw-mimes" ] || mkdir /tmp/raw-mimes

	# Fetch raw data.
	just _info "Fetching Apache data."
	wget -q -O "/tmp/raw-mimes/apache.txt" https://raw.githubusercontent.com/apache/httpd/trunk/docs/conf/mime.types

	just _info "Fetching Drupal data."
	wget -q -O "/tmp/raw-mimes/drupal.php" https://raw.githubusercontent.com/drupal/drupal/8.8.x/core/lib/Drupal/Core/File/MimeType/ExtensionMimeTypeGuesser.php

	just _info "Fetching FreeDesktop.org data."
	wget -q -O "/tmp/raw-mimes/freedesktop.xml" https://cgit.freedesktop.org/xdg/shared-mime-info/plain/data/freedesktop.org.xml.in

	just _info "Fetching IANA data."
	[ -d "/tmp/raw-mimes/iana" ] || mkdir -p /tmp/raw-mimes/iana
	rsync -qavz rsync://rsync.iana.org/assignments/media-types /tmp/raw-mimes/iana

	just _info "Fetching Nginx data."
	wget -q -O "/tmp/raw-mimes/nginx.txt" https://raw.githubusercontent.com/nginx/nginx/master/conf/mime.types

	just _info "Fetching Tika data."
	wget -q -O "/tmp/raw-mimes/tika.xml" https://raw.githubusercontent.com/apache/tika/master/tika-core/src/main/resources/org/apache/tika/mime/tika-mimetypes.xml

	just _info "Fetching WordPress data."
	wget -q -O "/tmp/raw-mimes/wp.php" https://raw.githubusercontent.com/WordPress/WordPress/master/wp-includes/functions.php

	# Crunch it!
	php "{{ skel_dir }}/build/build.php"

	# Clean up.
	just _fix_chown "{{ bin_dir }}"
	just _fix_chown "{{ lib_dir }}/righteous/mimes/data"



##                ##
# MISC DEVELOPMENT #
##                ##

# Initialization.
@_init: _requirements
	just _header "Righteous Sandbox"

	# Make sure Composer bits are up-to-date.
	just _composer

	# Show available tasks.
	just --list | grep -v 'Host:'


# Run unit tests.
@test: _requirements
	just _info "Running unit tests."

	phpunit || true
	just _fix_chown "{{ justfile_directory() }}/.phpunit.result.cache"


# Set library version.
@set-version VERSION: _requirements
	just _set-version "{{ VERSION }}" >/dev/null 2>&1
	just _success "Version set to $( cat "{{ justfile_directory() }}/composer.json" | jq '.version' | sed 's/"//g' )"


_set-version VERSION:
	#!/usr/bin/env php
	<?php

	$version = \preg_replace('/[^\d.]/', '', "{{ VERSION }}");
	if (! \preg_match('/^\d+\.\d+\.\d+$/', $version)) {
		exit(1);
	}

	$file = \realpath("{{ justfile_directory() }}/composer.json");
	if (! \is_file($file)) {
		exit(1);
	}

	$content = \trim(\file_get_contents($file));
	if (null === ($json = \json_decode($content, true))) {
		exit(1);
	}

	$json['version'] = $version;
	\file_put_contents($file, \json_encode($json, JSON_PRETTY_PRINT) . PHP_EOL);


# Watch code for changes.
@watch: _requirements
	just _info "Watching for changes."

	watchexec \
		--postpone \
		--no-shell \
		--watch "{{ lib_dir }}" \
		--watch "{{ skel_dir }}" \
		--watch "{{ test_dir }}" \
		--debounce 1000 \
		--exts php \
		-- just _watch_php



##               ##
# PHP DEVELOPMENT #
##               ##

# PHP tasks to execute on watch triggers.
@_watch_php:
	just _phpcs


# Composer tasks.
@_composer:
	just _info "Updating Composer."

	# Make sure Composer is set up.
	[ -d "{{ vendor_dir }}" ] || composer install -q -n -a
	[ -f "/tmp/composer-updated" ] || composer update -q -n -a > "/tmp/composer-updated"
	just _fix_chown "{{ vendor_dir }}"
	just _fix_chown "{{ justfile_directory() }}/composer.lock"


# PHP code standards.
@_phpcs:
	just _info "Linting PHP."

	phpcs \
		--colors \
		--standard=Blobfolio \
		--encoding=utf8 \
		-p \
		-s \
		--cache \
		--report=full \
		--extensions=php \
		--ignore="{{ vendor_dir }}" \
		"{{ lib_dir }}" "{{ skel_dir }}" "{{ test_dir }}"



##        ##
# INTERNAL #
##        ##

# Docker requirements.
@_host_requirements:
	# Docker should exist and be running.
	[ $( command -v docker ) ] || just _die "Docker is required."

	# Git is required.
	[ $( command -v git ) ] || just _die "Git is required."

	# Make sure the build environment exists.
	[ -d "{{ build_dir }}" ] || git clone https://github.com/Blobfolio/righteous-sandbox.git "{{ build_dir }}"

	# And we shouldn't be inside a container.
	just _no_docker



##       ##
# SANDBOX #
##       ##

# Host: Launch container build environment.
@sandbox: _host_requirements
	just _sandbox "launch" "{{ justfile_directory() }}"


# Host: Force a rebuild of the container build environment.
@sandbox-rebuild: _host_requirements
	just _header "Rebuilding Righteous Sandbox."

	[ ! -d "{{ build_dir }}" ] || rm -rf "{{ build_dir }}"
	git clone https://github.com/Blobfolio/righteous-sandbox.git "{{ build_dir }}"
	just _sandbox "rebuild"

	just _success "The container has been rebuilt."


# Run task from Sandbox justfile.
@_sandbox TASK +ARGS='':
	just --justfile "{{ build_dir }}/justfile" "{{ TASK }}" {{ ARGS }}


# Fix file/directory ownership.
@_fix_chown PATH:
	just _sandbox "_fix_chown" "{{ PATH }}"


# Ensure tasks are not run from within a container.
@_no_docker:
	just _sandbox "_no_docker"


# General requirements.
@_requirements:
	just _sandbox "_only_docker"



##             ##
# NOTIFICATIONS #
##             ##

# Task header.
@_header TASK:
	echo "\e[34;1m[Task] \e[0;1m{{ TASK }}\e[0m"

# Echo an informational comment.
@_info COMMENT:
	echo "\e[95;1m[Info] \e[0;1m{{ COMMENT }}\e[0m"

# Echo a warning.
@_warning COMMENT:
	>&2 echo "\e[33;1m[Warning] \e[0;1m{{ COMMENT }}\e[0m"

# Echo an error.
@_error COMMENT:
	>&2 echo "\e[31;1m[Error] \e[0;1m{{ COMMENT }}\e[0m"

# Error and exit.
@_die COMMENT:
	just _error "{{ COMMENT }}"
	exit 1

# Echo a success.
@_success COMMENT:
	echo "\e[92;1m[Success] \e[0;1m{{ COMMENT }}\e[0m"
