update-docs:
    sn c .
    rm -rf docs
    idris --mkdoc composition.ipkg
    mv composition_doc/ docs/
