bt:='0'
export RUST_BACKTRACE:=bt

# build chuck for linux alsa
alsa:
	@cd chuck
	@cd src
	pwd
	@compiledb make -- linux-alsa
	@echo 'Now run `sudo make install` in chuck/src directory'
# build chuck for linux pulseaudio
pulse:
  @cd chuck/src
  pwd
  @compiledb make -- linux-pulse
  @echo 'Now run `sudo make install` in chuck/src directory'
# build chuck for linux jack
jack:
  @cd chuck/src
  pwd
  @compiledb make -- linux-pulse
  @echo 'Now run `sudo make install` in chuck/src directory'
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
@spam:
	{ \
		figlet test; \
		cargo build --color always 2>&1; \
		cargo test  --color always -- --color always 2>&1; \
	} | less
# only run tests matching PATTERN
filter PATTERN: build
	@cargo test {{PATTERN}}
# test with backtrace
backtrace:
	RUST_BACKTRACE=1 cargo test
# build target
build:
	@cargo build
# check target
check:
	@cargo check
# watch for changes
watch COMMAND='test':
	@cargo watch --clear --exec {{COMMAND}}
version := `sed -En 's/version[[:space:]]*=[[:space:]]*"([^"]+)"/v\1/p' Cargo.toml`
# publish to crates.io
# publish: lint clippy test
# 	git branch | grep '* master'
# 	git diff --no-ext-diff --quiet --exit-code
# 	cargo publish
# 	git tag -a {{version}} -m 'Release {{version}}'
# 	git push github {{version}}

# clean up feature branch BRANCH
done BRANCH:
	@git checkout {{BRANCH}}
	@git pull --rebase github master
	@git checkout master
	@git pull --rebase github master
	@git branch -d {{BRANCH}}
# install just from crates.io, can be run from make by passing justfile to make as a makefile
install:
	@cargo install -f just
# install development dependencies
install-dev-deps:
	@rustup install nightly
	@rustup update nightly
	@rustup run nightly cargo install -f clippy
	@cargo install -f cargo-watch
	@cargo install -f cargo-check

# count non-empty lines of code
sloc:
	@cat src/*.rs | sed '/^\s*$/d' | wc -l
# count code with tokei
toke:
	@tokei
# find long lines and FIXMEs/TODOs
@lint:
	@echo Checking for FIXME/TODO...
	! grep --color -En 'FIXME|TODO' src/**/*.rs chuck/src/**/*.c chuck/src/**/*.cpp chuck/src/**/*.h
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
    @clang-tidy -enable-check-profile -explain-config -export-fixes=clang-tidy-fixes.yml -format-style=file -header-filter=.* -system-headers=0 -fix -fix-errors src/**/*.h* src/**/*.c src/**/*.cpp
# formats Rust code
rustfmt:
    @echo 'Formatting rust code...'
    @find {{invocation_directory()}} -name \*.rs -exec rustfmt -v {} \;
# aggressively try to fix Rust code for 2018 edition, disregarding errors
fix:
	@cargo fix --edition --edition-idioms --allow-no-vcs --broken-code
# generate ctags for symbol navigation
ctags:
    @echo 'Generating debugging ctags...'
    @ptags -v -s --validate-utf8 -f tags src
# generate rust tags for symbol navigation
rtags:
	@ptags -v -s --validate-utf8 -c --links=no -c --languages=Rust -f rtags src
# build chuck lexer using flex TODO: use nom
lex:
    @echo 'Building lexer'
    LEX=flex flex -osrc/chuck.yy.c src/chuck.lex
# build windows chuck lexer using flex TODO: use nom
lexwin:
    @echo 'Building win32 lexer'
    LEX=flex flex --nounistd -osrc/chuck.yy.c src/chuck.lex
    @/bin/cat src/chuck.tab.c src/chuck.yy.c > $@
# build LALR parser with bison TODO: use nom
bison:
    @echo 'Building parser'
    YACC=bison bison -dv -b src/chuck src/chuck.y
# clean build artifacts
cl:
    @echo 'Cleaning artifacts'
    @cd ../chuck-sys/src && pwd
    @make -j$(nproc) -v clean
    @cd ../../chuck_sys && pwd
    @cargo -v clean
    @rm -rfv src/**/*.o src/**/*.o achuck pchuck jchuck tags
# generate rust documentation
doc:
	@cargo doc --color always --all-features -j $(nproc) --no-deps
# generate c/c++ docs using doxygen
doxy:
	@doxygen Doxygen
# Local Variables:
# mode: makefile
# End:
# vim: set ft=make :
