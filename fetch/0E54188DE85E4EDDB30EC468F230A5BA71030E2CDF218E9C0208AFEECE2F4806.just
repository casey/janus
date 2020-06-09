
# Create the docker container used to run realmd
create extension revision path:
    docker build --build-arg BUILD_PATH={{ path }} -t amangos/reamld-{{ extension }}:{{ revision }} .
