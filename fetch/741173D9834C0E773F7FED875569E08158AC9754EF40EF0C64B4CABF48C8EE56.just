export date := "2019/10/27"
export version := "0.0.1"
export package := "mathnotes"

version_token := '${VERSION}$'
date_token := '${DATE}$'

needs_version := "mathnotes.sty mathnotes.cls"
dist_files := "mathnotes.sty mathnotes.cls mathnotes-util.sty mathnotes-messages.sty mathnotes-hw.cls mathnotes-formula-sheet.cls"

_dir-no-pdf:
	mkdir -p '{{ package }}'
	cp -t '{{ package }}' {{ dist_files }}
	@echo "Replacing version placeholder in distribution files."
	cd '{{ package }}' && sd -s '{{ version_token }}' '{{ version }}' {{ needs_version }}
	cd '{{ package }}' && sd -s '{{ date_token }}' '{{ date }}' {{ needs_version }}

install texmf:
	just _dir-no-pdf
	install -d '{{ texmf }}/tex/latex/{{ package }}'
	cd '{{ package }}' && install -m 644 {{ dist_files }} '{{ texmf }}/tex/latex/{{ package }}'
