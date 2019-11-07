bt='0'
export RUST_BACKTRACE=bt
export BGFLAGS="--enable-cxx-namespaces --conservative-inline-namespaces --builtins --enable-function-attribute-detection --generate-block --impl-debug --impl-partialeq --with-derive-default --with-derive-eq --with-derive-hash --with-derive-ord"
# run clippy
clip:
	@cargo clippy
# run executable
run:
	@cargo run
# pull git submodules
subf:
	@git submodule foreach git pull origin master
# init git submodules
subu:
	@git submodule update --init --recursive
# init rustfmt.toml
form:
	@rustfmt --print-config default rustfmt.toml
# run tests
test: build
	@cargo test
# build target
build:
	@cargo build
# check target
check:
	@cargo check
# install just from crates.io, can be run from make by passing justfile to make as a makefile
install:
	@cargo install -f just
# count non-empty lines of code
sloc:
	@cat src/*.rs | sed '/^\s*$/d' | wc -l
# count code with tokei
toke:
	@tokei
# find long lines and FIXMEs/TODOs
@lint:
	@echo Checking for FIXME/TODO...
	! grep --color -En 'FIXME|TODO' src/**/*.rs src/**/*.c src/**/*.cpp src/**/*.h
	@echo Checking for long lines...
	! grep --color -En '.{101}' src/*.rs
# simple sed replacement in rust files
replace FROM TO:
	@find src -name '*.rs' | xargs sed -i '' -E 's/{{FROM}}/{{TO}}/g'
# generate rust changelog
clog:
	@echo 'Generating Rust changelog...'
	@changelog -vP -o CHANGELOG.md
# tidy and format c/c++ code with llvm tools
fmt:
	@echo 'Tidying and Formatting C/C++ code...'
	clang-tidy -enable-check-profile -explain-config -export-fixes=clang-tidy-fixes.yml -format-style=file -header-filter=.* -system-headers=0 -fix -fix-errors src/ck/**/*.h* src/ck/**/*.c src/ck/**/*.cpp src/io/**/*.h src/io/**/*.cpp src/stk/include/*.h src/stk/src/*.cpp
# formats Rust code
rustfmt:
	@echo 'Formatting rust code...'
	#@find {{invocation_directory()}} -name \*.rs -exec rustfmt -v {} \;
	@rustfmt -v --emit files --edition 2018 --color always --unstable-features **/*.rs
# aggressively try to fix Rust code for 2018 edition, disregarding errors
fix:
	@cargo fix --edition --edition-idioms --allow-no-vcs --broken-code
# generate ctags for symbol navigation
tags:
	@echo 'Generating debugging ctags...'
	# ctags --tag-relative --extra=f -R src
	@ptags -v -s --validate-utf8 -f tags src
# generate rust tags for symbol navigation
rtags:
	@ptags -v -s --validate-utf8 -c --links=no -c --languages=Rust -f tags src
# generate rust documentation
doc:
	@cargo doc --color always --all-features -j $(nproc) --no-deps
# generate c/c++ docs using doxygen
doxy:
	@cd ../chuck && pwd
	@doxygen Doxygen
	@cd ../chuck_sys && pwd
# build faust system
make:
	@make all
# Local Variables:
# mode: makefile
# End:
# vim: set ft=make :
