# 
# branch: recursively get paths quickly. 
# https://github.com/lptstr/branch
#

# ----- VARIABLES -----

# hint: it's probably not a good idea to change this!
BUILDDIR  := "build"
PLATFORM  := `gcc -dumpmachine`

CARGOPTS := "build -j`nproc` --target-dir " + BUILDDIR
CARGOBIN := 'cargo'

CARGOPT_RELEASE := CARGOPTS + " --release"

PREFIX := '/usr'
DESTDIR := '/bin'

# ----- RECIPES -----
all: options debug

clean:
	rm -f "build/release/branch"
	rm -f "build/debug/branch"

options:
	@echo "OPTIONS:"
	@echo "\tCC\t\t\t= {{CARGOBIN}}"
	@echo "\tCCFLAGS\t\t\t= {{CARGOPTS}}"
	@echo "\tCCFLAGS_RELEASE\t\t= {{CARGOPT_RELEASE}}"
	@echo "\tPLATFORM\t\t= {{PLATFORM}}"
	@echo ""

dev-install:
	install -m 755 "build/debug/branch" "{{PREFIX}}{{DESTDIR}}/branch"

install:
	install -m 755 "build/release/branch" "{{PREFIX}}{{DESTDIR}}/branch"

uninstall:
	rm -f "{{PREFIX}}{{DESTDIR}}/branch"

debug: options
	@echo "CC {{CARGOPTS}}"
	@{{CARGOBIN}} {{CARGOPTS}}

release: options
	@echo "CC {{CARGOPT_RELEASE}}"
	@{{CARGOBIN}} {{CARGOPT_RELEASE}}
