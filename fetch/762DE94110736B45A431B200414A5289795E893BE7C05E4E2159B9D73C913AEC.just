# justfile, see: https://github.com/casey/just

default: gen

gen:
	./bin/gen

capture:
	./bin/gen --capture

open:
	open 'http://localhost'

serve:
	cd docs && sudo ../bin/serve

watch:
	fswatch -ro . | xargs -n1 ./bin/gen
