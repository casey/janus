help:
  @just --list


# Compile and watch sass
sass:
  ./node_modules/.bin/sass --watch src/styles.scss docs/styles.css


# Run autoload
reload:
  ./node_modules/.bin/autoreload-server docs
