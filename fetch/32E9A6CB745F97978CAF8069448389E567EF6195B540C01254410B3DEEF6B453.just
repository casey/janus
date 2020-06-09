latex DOCTYPE="resume":
    python3 src/generate.py latex {{DOCTYPE}}

md DOCTYPE="resume":
    python3 src/generate.py md {{DOCTYPE}}

watch-pdf DOCTYPE="resume":
    watchexec -- just pdf {{DOCTYPE}}

pdf DOCTYPE="resume":
    python3 src/generate.py latex {{DOCTYPE}} > target/david_purdum_{{DOCTYPE}}.tex
    pdflatex -halt-on-error -output-directory target target/david_purdum_{{DOCTYPE}}.tex 
    @trash target/*.log
    @trash target/*.aux

open-pdf DOCTYPE="resume":
    just pdf {{DOCTYPE}}
    zathura target/david_purdum_{{DOCTYPE}}.pdf &

clean:
    trash target/*
    trash src/__pycache__/
