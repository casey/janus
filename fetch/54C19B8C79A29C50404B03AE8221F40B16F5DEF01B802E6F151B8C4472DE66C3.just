release:
    @git commit -am "release"
    @git tag "$(git tag --list | tail -n1 | awk -F. '{$NF+=1; print $0}' | rg ' ' --replace '.')"
    @bower install
    @pulp publish

test:
    @pulp --psc-package test

build:
    @pulp --psc-package build
