default: test

test:
	./bin/test

watch:
	watchexec --clear 'cat input.py | python3 reap.py'

preview: readme
	macdown README.md

readme:
	./bin/generate-readme
