build:
	@./build.py
rebuild-macro-expander:
	@./build.py --rebuild-macro-expander
watch:
	@watchexec -cre oft -i env.oft -i prelude.oft -i \*.ofta -- ./build.py --no-oftb-build
