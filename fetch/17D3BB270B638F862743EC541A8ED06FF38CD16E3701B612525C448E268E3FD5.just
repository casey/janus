# just a makefile with no special magic

# list all recipies by default
default:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | xargs

# make a quine and compile it
quine: create compile

# create our quine
create:
	mkdir -p tmp
	echo 'int printf(const char*, ...); int main() { char *s = "int printf(const char*, ...); int main() { char *s = %c%s%c; printf(s, 34, s, 34); return 0; }"; printf(s, 34, s, 34); return 0; }' > tmp/gen0.c

# make sure it's really a quine
compile:
	cc tmp/gen0.c -o tmp/gen0
	./tmp/gen0 > tmp/gen1.c
	cc tmp/gen1.c -o tmp/gen1
	./tmp/gen1 > tmp/gen2.c
	diff tmp/gen1.c tmp/gen2.c
	@echo 'It was a quine!'

# clean up
clean:
	rm -r tmp

# demonstrate the use of positional arguments
args:
	@echo "I got some arguments: ARG0=$$ARG0 ARG1=$$ARG1 ARG2=$$ARG2"

# put symlinks to just into ~/bin
install:
	mkdir -p ~/bin
	ln -s $$PWD/just ~/bin/just
	ln -s $$PWD/just ~/bin/j

uninstall:
	if test -L ~/bin/j ; then \
		READLINK=`readlink ~/bin/j` ; \
		if test $$READLINK = $$PWD/just ; then unlink ~/bin/j ; fi ; \
	fi
	if test -L ~/bin/just ; then \
		READLINK=`readlink ~/bin/just` ; \
		if test $$READLINK = $$PWD/just ; then unlink ~/bin/just ; fi ; \
	fi

version := 0.2.0
tarball := just-$(version).tar.gz
tardir  := just-$(version)

release:
	rm -f $(tarball)
	mkdir $(tardir)
	cp just $(tardir)
	tar zcvf $(tarball) $(tardir)
	rm -rf $(tardir)

checksum:
	openssl dgst -rmd160 $(tarball)
	openssl dgst -sha256 $(tarball)
