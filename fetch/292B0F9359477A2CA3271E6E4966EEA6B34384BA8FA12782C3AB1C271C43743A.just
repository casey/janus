all: examples
examples:
	just compile examples/*.sd
watch TARGETS="":
	watchexec -cre sd,sv "just {{TARGETS}}"

build-compiler:
	silver xyz:remexre:simpdep:compiler

compile +FILES: build-compiler
	for file in {{FILES}}; do java -jar xyz.remexre.simpdep.compiler.jar "$file"; done
