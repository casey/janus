#!/usr/bin/env just --justfile

default:
	just --list

test:
	go test ./...
