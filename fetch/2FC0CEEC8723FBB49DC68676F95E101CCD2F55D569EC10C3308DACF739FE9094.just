build:
    R CMD build ../junr
    R CMD INSTALL *.tar.gz
    rm *.tar.gz
document:
    R -e "devtools::document('../junr')"
