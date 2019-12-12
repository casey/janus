default:
    watchexec --clear -e tex,bib -i . just build 

build:
    just clean
    pdflatex main
    bibtex main
    pdflatex main
    pdflatex main

clean:
    rm -vf *.aux
    rm -vf *.log
    rm -vf *.blg
    rm -vf *.bbl
    rm -rf *.toc
