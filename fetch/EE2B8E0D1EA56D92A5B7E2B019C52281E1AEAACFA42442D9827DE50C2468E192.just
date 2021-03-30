#!/usr/bin/env just --justfile

TARGET_BASE_DIR := '../build'
TARGET_TEST_DIR := TARGET_BASE_DIR + '/tests'

_default:
	@just --list

# all
all: clean unit integration

## test terraform w/o deploying etc.
unit:
	@./standard-targets-tests.sh

# integration test w/ deploying terraform stack
integration:
	@./integration-tests.sh

clean:
	@rm -rf {{TARGET_TEST_DIR}}

_ensure_target_dir_exists:
	@mkdir -p {{TARGET_TEST_DIR}}
