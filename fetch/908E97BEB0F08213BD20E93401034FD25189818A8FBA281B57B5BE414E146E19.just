unpack-test-data:
    rm -rf test-cases
    tar xzf test-cases.tar.gz

pack-test-data:
    tar czf test-cases.tar.gz test-cases
