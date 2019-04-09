docs-gen:
    pdflatex main
    pdflatex main
    open main.pdf

docs-clean:
    rm *.aux
    rm *.log
    rm *.out



