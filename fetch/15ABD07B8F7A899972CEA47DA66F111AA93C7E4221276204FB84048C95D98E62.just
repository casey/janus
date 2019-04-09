help:
  @just --list


#
# Dev:
#


# Compile and watch sass
sass:
  ./node_modules/.bin/sass --watch src/styles.scss docs/styles.css


# Run autoload
reload:
  autoreload-server docs
