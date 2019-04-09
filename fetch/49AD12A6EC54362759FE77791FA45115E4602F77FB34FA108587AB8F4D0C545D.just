# wengwengweng

bin_path = "/usr/local/bin"
share_path = "/usr/local/share"

run:
	tup
	cd example; \
		./../bin/dirty fish

install:
	install bin/dirty {{bin_path}}
	mkdir -p {{share_path}}/dirty
	mkdir -p {{share_path}}/dirty/macos
	cp bin/dirty {{share_path}}/dirty/macos

tags:
	ctags -f .tags -R src

loc:
	find src -name '*.cpp' -or -name '*.hpp' | xargs wc -l

