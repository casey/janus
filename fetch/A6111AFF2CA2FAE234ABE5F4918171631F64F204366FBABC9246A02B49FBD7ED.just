build:
  scripts/build

test:
  docker run -it dataland:latest pytest

run:
  docker run dataland:latest python dataland/scheduler.py
