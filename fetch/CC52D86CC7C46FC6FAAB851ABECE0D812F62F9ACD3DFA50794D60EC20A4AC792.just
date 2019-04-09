default: run

run: build
	./tmp/main --resolution=xga --route=blaster --left=10

build:
	tup

init:
	tup init

clean:
	rm -rf tmp

deps:
	brew install tup astyle glfw yajl portmidi portaudio fftw
	echo "syphon framework from: http://syphon.v002.info"
	echo "loopback from https://rogueamoeba.com/loopback"

package: build
	cp ./tmp/main ./tmp/rmr
	./bin/icon `./bin/pick ./rsc/icon/*.rsrc` ./tmp/rmr

db:
	lldb -- ./tmp/rmr --resolution=debug --route=blaster --left=10

sloc:
	cat `find -E src ! -name vec.c++ ! -name vec.h -regex '.*[.](c\+\+|cpp|h|glsl)'` | sed '/^\s*$$/d' | wc -l
