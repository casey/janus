_help:
    @just --list --unsorted

# build gem
build:
    bundle exec rake build

# remove built gems
clean:
    rm --force --verbose pkg/*

# build and install the gem globally to the system
install:
    bundle exec rake install

# deploy the gem to rubygems.org
release:
    bundle exec rake release

# run tests
test:
    bundle exec rspec
    @echo
    @echo xdg-open coverage/index.html
