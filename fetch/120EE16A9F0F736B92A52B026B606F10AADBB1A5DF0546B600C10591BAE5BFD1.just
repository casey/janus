build target:
	as "{{target}}/code.s" -o "{{target}}/obj.o"
	ld "{{target}}/obj.o" -o "{{target}}/exe"

run target: (build target)
	"{{target}}/exe" < "{{target}}/inp.txt"

run2 target: (build target)
	"{{target}}/exe" - < "{{target}}/inp.txt"

runex target: (build target)
	"{{target}}/exe" < "{{target}}/example.txt"

runex2 target: (build target)
	"{{target}}/exe" - < "{{target}}/example.txt"

runstd target: (build target)
	"{{target}}/exe"

runstd2 target: (build target)
	"{{target}}/exe" -

test target:
	as "{{target}}/tests.s" -o "{{target}}/tests.o"
	ld "{{target}}/tests.o" -o "{{target}}/tests"
	"{{target}}/tests"

dbg target: (build target)
	#!/bin/sh
	set -e
	if type ugdb >/dev/null; then
		ugdb "{{target}}/exe"
	else
		gdb "{{target}}/exe"
	fi

init target:
	mkdir "{{target}}"
	cp template.s "{{target}}/code.s"
	: Enter example input, end with ^D:
	cat > "{{target}}/example.txt"
	: Enter main input, end with ^D:
	cat >> "{{target}}/inp.txt"
