# just docs: https://github.com/casey/just

set shell := ["bash", "-c"]

_help:
    @just --list

# import * as semver from "https://deno.land/x/semver/mod.ts";
# Publish a new tagged release
@publish:
    echo "TODO: publish new tag with a single command"

test:
    deno test

watch_and_test:
    watchexec --exts ts -- deno test --allow-run
