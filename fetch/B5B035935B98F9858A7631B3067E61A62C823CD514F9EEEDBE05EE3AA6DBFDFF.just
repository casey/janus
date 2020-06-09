uid := `id -u`
gid := `id -g`
mvn := "mvn -Dmaven.repo.local=/build/.m2"

run: (_docker_run mvn 'hpi:run')
build: (_docker_run mvn 'compile')
check-updates: (_docker_run mvn 'versions:display-dependency-updates')
package: clean (_docker_run mvn 'compile' 'hpi:hpi')

_docker_run +args:
    docker run --rm -it \
        -v {{invocation_directory()}}:/build \
        -v $HOME:/root -e HOME=/root \
        -p 8080:8080 -w /build \
        maven:3.6-jdk-8 bash -c \
        'useradd -u {{uid}} -d /build build && su build bash -c "{{args}}"'

clean:
    just _docker_run {{mvn}} clean
    rm -rf work/
