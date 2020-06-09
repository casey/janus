install:
	dune external-lib-deps --missing @runtest

test:
	dune runtest

publish:
	git tag -a 0.3.0
	git push origin 0.3.0
	opam publish