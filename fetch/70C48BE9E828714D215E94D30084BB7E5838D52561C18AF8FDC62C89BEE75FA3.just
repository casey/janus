NAME = "hello"

@_default:
    just -l

# removes build artifacts
@clean:
    rm -f *.jar *.kexe

# compile the app for java runtime
lib:
    kotlinc {{ NAME }}.kt -d {{ NAME }}.jar

# compile the app for java runtime
buildj:
    kotlinc {{ NAME }}.kt -d {{ NAME }}.jar -include-runtime

# compile the app for native in debug mode
build:
    kotlinc-native {{ NAME }}.kt -o {{ NAME }}

# compile the app for native in release mode
release:
    kotlinc-native {{ NAME }}.kt -o {{ NAME }} -opt

# runs the jar as an app
@runj:
    java -jar {{ NAME }}.jar

# runs the native app
@run:
    ./{{ NAME }}.kexe

# runs a lib with an external kotlin runtime
@run-lib:
    kotlin -classpath {{ NAME }}.jar HelloKt
