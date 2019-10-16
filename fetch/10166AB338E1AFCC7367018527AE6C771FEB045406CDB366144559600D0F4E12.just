all: setup test run

setup:
  pip3 install pytest

test:
  pytest

run:
  python3 src/vanilla.py

watch:
  fd | entr -cr just test
