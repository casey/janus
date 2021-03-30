build:
	mkdir build
	javac -d build src/*.java

gen-ast:
	python tool/generate-ast.py src

clean:
	rm -rf build

run file='""':
  #!/usr/bin/env bash
  if [[ {{file}} == "" ]]; then
    cd build && java com.andrewhalle.lox.Lox
  else
    cd build && java com.andrewhalle.lox.Lox ../{{file}}
  fi
