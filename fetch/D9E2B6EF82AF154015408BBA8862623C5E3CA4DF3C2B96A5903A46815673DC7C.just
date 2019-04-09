build:
    R CMD build ../ixplorer
    R CMD INSTALL *.tar.gz
    rm *.tar.gz
