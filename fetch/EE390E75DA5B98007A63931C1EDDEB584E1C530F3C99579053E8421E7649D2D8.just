# wengwengweng

proj = "linked_list"

c:
	mkdir -p bin
	cc {{proj}}/{{proj}}.c -o bin/{{proj}}
	./bin/{{proj}}

cpp:
	mkdir -p bin
	g++ {{proj}}/{{proj}}.cpp -o bin/{{proj}}
	./bin/{{proj}}

rust:
	mkdir -p bin
	rustc {{proj}}/{{proj}}.rs -o bin/{{proj}}
	./bin/{{proj}}

lua:
	lua {{proj}}/{{proj}}.lua

go:
	go run {{proj}}/{{proj}}.go

js:
	node {{proj}}/{{proj}}.js

swift:
	swift {{proj}}/{{proj}}.swift

ruby:
	ruby {{proj}}/{{proj}}.rb

perl6:
	perl6 {{proj}}/{{proj}}.p6

python:
	python {{proj}}/{{proj}}.py

java:
	java {{proj}}/{{proj}}.java

clean:
	rm -rf bin

