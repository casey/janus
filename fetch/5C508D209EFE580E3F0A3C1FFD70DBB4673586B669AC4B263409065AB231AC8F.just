# board := "TinyCircuits:samd:tinyscreen"
board := "TinyCircuits:samd:tinyzero"
project := "."

flash: compile upload

compile:
	@mkdir -p bin
	arduino-cli compile --fqbn {{board}} {{project}} -o bin/bin.TinyCircuits.samd.tinyzero.bin

upload:
	sudo ~/bin/arduino-cli upload -p /dev/ttyACM0 --fqbn {{board}} bin/

install:
	arduino-cli core update-index --additional-urls https://tiny-circuits.com/Downloads/ArduinoBoards/package_tinycircuits_index.json
	arduino-cli core install TinyCircuits:samd --additional-urls https://tiny-circuits.com/Downloads/ArduinoBoards/package_tinycircuits_index.json
	arduino-cli lib install RTCZero
	arduino-cli lib install TinyScreen
	arduino-cli lib install "Arduino Low Power"

# microcom to read output on Linux
# There are other options listed here, but they don't seem better
# https://playground.arduino.cc/Interfacing/LinuxTTY/
#
# quite with: ctrl + /
read:
	#!/usr/bin/env bash
	set -eu
	while ! arduino-cli board list 2>/dev/null | grep ttyACM0 ; do
		if arduino-cli board list 2>&1 | grep "dial tcp: lookup " >/dev/null ; then
			echo "offline, skipping board list"
			break
		fi
		echo "waiting for board to show up with a tty"
	done
	microcom -s 9600 -p /dev/ttyACM0

all: compile upload read
