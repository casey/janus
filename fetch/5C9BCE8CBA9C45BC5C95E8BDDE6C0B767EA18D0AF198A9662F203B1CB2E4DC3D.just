build:
    @echo "Building..."
    @cmake -G Ninja .
    @ninja

run: build
    @./Deadspell

lint: build
    clang-tidy --quiet --format-style='file' --fix ./**/*.cpp