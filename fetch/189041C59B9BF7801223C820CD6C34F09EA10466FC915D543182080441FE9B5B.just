compile-exec:
    GRAALVM_HOME=/usr/lib/jvm/java-11-graalvm/ clojure -M:native-image

build: compile-exec
    gzip --force ./mdsort

test:
    clj -X:test

# Local Variables:
# mode: makefile
# End:
# vim: set ft=make :
