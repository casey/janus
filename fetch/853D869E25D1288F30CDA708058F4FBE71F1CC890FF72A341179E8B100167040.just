.phony: repos configs

default:
	./main | tee README.md

fetch:
	./find-dotbot-repos | ./fetch-configs
