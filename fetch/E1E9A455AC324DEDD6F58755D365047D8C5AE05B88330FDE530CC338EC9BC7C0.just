check-fmt:
        cargo fmt -- --write-mode=diff

check-rst:
        rst check

#check-build:
#        cargo check

check: check-rst check-fmt check-build

