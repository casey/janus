BIN := 'bundle exec ruby -Ilib bin/enparallel'

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

# run the gem's binary
run +args:
    {{ BIN }} "{{ args }}"

# run tests
test:
    bundle exec rspec
    @echo
    @echo xdg-open coverage/index.html

# build the asciicasts of enparallel in action
build-readme:
    tools/build-readme

# run 50 unpredictable tasks
run-50:
    seq 50 | {{ BIN }} --workers 32 --pick random -- tools/unpredictable-task
