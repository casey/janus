
help:
  @just -l

pkg:
    rm -f elk.tar.gz
    tar -zcv --exclude='Justfile' -f elk.tar.gz *
