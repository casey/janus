doc:
    cargo doc
    mkdir -p target/doc
    asciidoctor -o target/doc/README.html README.adoc

serve: doc
    (cd target/doc && python3 -m http.server)

