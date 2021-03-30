bold := "\\033[1m"
red := "\\033[0;91m"

check:
	cargo clippy --release

build: check
	platformio run

upload: check kill_plot
	platformio run --target upload

clean:
	cargo clean
	platformio run --target clean

@kill_plot:
	test -e ~/.cache/arduino-plotter.pid \
		&& cat ~/.cache/arduino-plotter.pid \
		| xargs pkill -P && rm ~/.cache/arduino-plotter.pid \
	|| echo -e "{{red}}Plotter had not been started. {{bold}}Ignoring request."

@plot:
	arduino-plotter > /dev/null & echo $! > ~/.cache/arduino-plotter.pid
	echo -e "{{bold}}Plotter has been started"

serial port:
	@ echo -e "{{bold}}Waiting 1.5 seconds to allow serial port to open"
	@ sleep 1.5
	@ test -e {{port}} || (echo -e "{{red}}Serial port {{bold}}{{port}}{{red}} does not exist!" && exit 1)
	screen {{port}}
	stty -F {{port}} hupcl