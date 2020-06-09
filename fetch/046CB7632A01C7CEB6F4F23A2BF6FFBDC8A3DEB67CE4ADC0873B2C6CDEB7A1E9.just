
# Create the docker container used to extract maps
create extension path:
    docker build --build-arg BUILD_PATH={{ path }} -t amangos/extractor-{{ extension }} .
