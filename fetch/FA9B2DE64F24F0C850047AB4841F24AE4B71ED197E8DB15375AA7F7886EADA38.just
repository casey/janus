clean:
    rm -rf target

build: clean
    mkdir -p target
    ahc-cabal new-install exe:asterius-sandbox . --symlink-bindir target

dist: build
    ahc-dist --browser --input-exe target/asterius-sandbox --output-directory target
    mv target/asterius-sandbox.html target/index.html

serve:
    warp -d target -p 8080