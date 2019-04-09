build:
    R CMD build ../gitear
    R CMD INSTALL *.tar.gz
    rm *.tar.gz
