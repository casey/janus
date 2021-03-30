default:
    just run hello_world.c

compile *FILE:
    clang -Wall -lm -Wextra -pedantic -std=c99 {{FILE}}

run FILE *ARGS:
    @just compile {{FILE}}
    ./a.out {{ARGS}}

new FILE:
    cp hello_world.c {{FILE}}

rat:
    @just compile modern_c/rat/rat_test.c modern_c/rat/rationals.c
    ./a.out

kilo *FILE:
    just run kilo/kilo.c {{FILE}}
