export version := "2019/10/15 0.2.0"
export package := "rebeccastyle"

version_token := '${VERSION}$'

cls := "rebeccaessay.cls"
needs_latexmk := package + ".tex"
needs_version := package + ".sty " + cls + " " + package + ".tex"
dist_files := package + ".sty " + cls + ""
doc_files := package + ".tex LICENSE.md README.md"

latexmk := "latexmk -pdf -r " + invocation_directory() + "/.latexmkrc -pvc- -pv-"
latexmk_clean := "latexmk -c"
clean_files := "extra *.fls"
export tar := package + ".tar.gz"

_dir-no-pdf:
	mkdir -p '{{ package }}'
	cp -t '{{ package }}' {{ dist_files }} {{ doc_files }}
	@echo "Replacing version placeholder in distribution files."
	cd '{{ package }}' && sd -s '{{ version_token }}' '{{ version }}' {{ needs_version }}

_dir-pdf:
	just _dir-no-pdf
	@echo "Building PDFs for {{ needs_latexmk }}"
	cd '{{ package }}' && {{ latexmk }} {{ needs_latexmk}}

_package:
	just _dir-no-pdf _dir-pdf
	chmod -x,+r {{ package }}/*.*
	cd '{{ package }}' && {{ latexmk_clean }} && rm -rf {{ clean_files }}

# Create the distribution rebeccastyle.tar.gz
dist:
	just _package
	tar -czf '{{ tar }}' '{{ package }}'
	just tidy
	tar -tvf '{{ tar }}'

# Delete all generated files except .pdfs and the .tar.gz.
tidy:
	{{ latexmk_clean }}
	# copied files
	rm -rf '{{ package }}' extra

# = clean
distclean:
# Delete all generated files.
clean:
	{{ latexmk }} -C
	just tidy
	rm -f '{{ tar }}'

install texmf:
	just _dir-no-pdf
	install -d '{{ texmf }}/tex/latex/{{ package }}'
	cd '{{ package }}' && install -m 644 {{ dist_files }} '{{ texmf }}/tex/latex/{{ package }}'
