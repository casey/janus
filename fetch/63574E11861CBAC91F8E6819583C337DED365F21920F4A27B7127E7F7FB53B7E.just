bo = "binary_outcome"

polyglot: pymc stan cpp

pymc:
    python3 {{bo}}.py

stan:
   Rscript {{bo}}_stan.R

cpp:
   Rscript {{bo}}_cpp.R
