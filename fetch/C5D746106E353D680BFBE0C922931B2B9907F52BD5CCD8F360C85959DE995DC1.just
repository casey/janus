
all: sync packages other

other:
	tree -L 2 ~/Programs/ > other-programs.txt

packages: pkg-npm pkg-yarn pkg-python

pkg-npm:
	npm list -g --depth=0  2>/dev/null >npm-global.txt || return 0

pkg-yarn:
	rsync -ui ~/.config/yarn/global/package.json yarn-global.json

pkg-python:
	pip freeze > python-global.txt

pkg-rust:
	ls ~/.cargo/bin > rust-global.txt

sync: etc udev

etc:
	just pull_file /etc/X11/xorg.conf.d
	just pull_file /etc/anacrontab
	just pull_file /etc/apt/apt.conf.d/00aptitude
	just pull_file /etc/bumblebee
	just pull_file /etc/crontab
	just pull_file /etc/davfs2/davfs2.conf
	just pull_file /etc/dictd
	just pull_file /etc/fstab
	just pull_file /etc/hostapd
	just pull_file /etc/hosts
	just pull_file /etc/udhcpd.conf
	just pull_file /etc/vsftpd.conf
	just pull_file /etc/dhcpcd.conf
	just pull_file /etc/X11

udev:
	just pull_file /lib/udev/rules.d/98-backlight.rules
	just pull_file /lib/udev/rules.d/99-ds4-controllers.rules

pull_file FILE:
	#!/usr/bin/env sh
	if [ ! -e "{{FILE}}" ]; then
		echo [E]: "{{FILE}}" does not exist
		exit 0
	fi
	
	d=`dirname "{{FILE}}" | sed "s/^\///"`
	if [ ! -d "$d" ]; then
		mkdir -p "$d"
	fi
	rsync -puir "{{FILE}}" "$d"
