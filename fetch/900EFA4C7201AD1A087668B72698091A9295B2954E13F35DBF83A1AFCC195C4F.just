# -------
# TESTING

# Compile the catch framework
compile-catch:
    g++ tests/catch.cpp -c -o bin/catch.o

# Compile the test suite
compile-test-suite:
    g++ bin/catch.o tests/suite.cpp -o bin/test -O3

# Test using catch framework
alias t := test
test *TAGS: compile-test-suite
    bin/test {{ TAGS }}

# ------------
# BENCHMARKING
    
# Time an individual delta computation
bench-delta ALG N:
    g++ bench/delta.cpp -o bin/bench -O3
    time -p bin/bench {{ ALG }} {{ N }} 

# Time a range of delta computations
bench-deltas ALG START END:
    g++ bench/deltas.cpp -o bin/bench -O3
    time -p bin/bench {{ ALG }} {{ START }} {{ END }}

# Time a multiplier up to a given range
bench-multiplier ALG MULTIPLIER END:
    g++ bench/multiplier.cpp -o bin/bench -O3
    time -p bin/bench {{ ALG }} {{ MULTIPLIER }} {{ END }}

# --------------
# OTHER COMMANDS

# Delete executables
clean:
    trash bin/*

alias tm := test-multiplier
test-multiplier MULTIPLIER:
    g++ tests/alg2_alg3.cpp -o bin/test -O3
    bin/test {{ MULTIPLIER }}
    @echo "Success!"

alias b := bench
bench BENCH START END:
    g++ bench/{{ BENCH }}.cpp -o bin/bench -O3
    time -p bin/bench {{ START }} {{ END }}
    @play ~/Downloads/alert.mp3 -q 2> /dev/null

alias bs := bench-sieve
bench-sieve SIEVE SIZE:
    g++ bench/sieve/{{ SIEVE }}.cpp -o bin/bench-sieve -O3
    time -p bin/bench-sieve {{ SIZE }}

alias bss := bench-segmented-sieve
bench-segmented-sieve SIZE SEGMENT:
    g++ bench/sieve/segmented_sieve.cpp -o bin/bench-sieve -O3
    # time -p bin/bench-sieve {{ SIZE }} {{ SEGMENT }}

alias m := gen-multiplier
gen-multiplier ALG MULTIPLIER:
    g++ multipliers/{{ ALG }}.cpp -o bin/multiplier -O3
    time -p bin/multiplier {{ MULTIPLIER }}
    wc -l results/multipliers/deltas_max4294967296_m{{ MULTIPLIER }}.txt
    @play ~/Downloads/alert.mp3 -q 2> /dev/null

alias pm := par-multiplier
par-multiplier NP:
    mpicxx multipliers/pshift.cpp -o bin/pmultiplier -O3
    mpirun -q -np {{ NP }} bin/pmultiplier

# Compiles, runs and times a cpp file
run PATH:
    g++ {{ PATH }} -o bin/run -O3
    bin/run

# Compiles every benchmark and test
compile:
    #!/bin/bash
    for filename in tests/*.cpp; do
       g++ $filename -c -o /tmp/a.out
    done
    for filename in bench/*.cpp; do
       g++ $filename -c -o /tmp/a.out
    done
    for filename in multipliers/*.cpp; do
       g++ $filename -c -o /tmp/a.out
    done
