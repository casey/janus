
GROUP_ID := env_var('GROUP_ID')
ARTIFACT_ID := env_var('ARTIFACT_ID')
VERSION_ID := `cat version_id`

TARGET_FOLDER := 'target'

YELLOW_COLOR := '\033[0;33m'
GREEN_COLOR := '\033[0;92m'
NORMAL_TEXT := '\033[0m'
CURRENT_TIME := `date`
CURRENT_OS := os()

##################################################################################################################

# Help
default:
    @echo "List of available recipes"
    @just --list

# Install project requirements (OS will be detected automatically)
requirements:
    @{{ if CURRENT_OS == 'macos' {"just _macos-requirements" } else {""} }}
    @{{ if CURRENT_OS == 'linux' {"just _linux-requirements" } else {""} }}

# Install project requirements for MacOS
_macos-requirements:
    @just _cmdprint "Installing MacOS requirements...\n"
    -brew install git
    -brew install coreutils
    -brew install direnv
    -brew install cljstyle && xattr -r -d com.apple.quarantine /usr/local/bin/cljstyle
    -brew install borkdude/brew/clj-kondo

    @just _cprint '{{YELLOW_COLOR}}' "\nDon't forget to install 'direnv' hook for your shell.\n"
    @echo 'zsh hook example:'
    @echo '\teval "$(direnv hook zsh)"\n'


# Install project requirements for Linux
_linux-requirements:
    @echo "Installing Linux requirements...is not implemented."
    @echo "Please, ensure that the following tools are installed: git, direnv, cljstyle, clj-kondo."
    @exit 1

# Print command name
_cmdprint text:
    #!/usr/bin/env bb
    (println "-----------------------------------------------")
    (import 'java.time.format.DateTimeFormatter 'java.time.LocalDateTime)
    (def date (LocalDateTime/now))
    (def formatter (DateTimeFormatter/ofPattern "yyyy-MM-dd HH:mm:ss"))
    (printf "{{GREEN_COLOR}}%s\n"(.format date formatter))
    (println "{{YELLOW_COLOR}}{{text}}{{NORMAL_TEXT}}")

_cprint color text:
    #!/usr/bin/env bb
    (println "{{color}}{{text}}{{NORMAL_TEXT}}")

##################################################################################################################

# Clean target folder
clean:
    @just _cmdprint "Clean target folder...\n"
    @rm -rf ./{{TARGET_FOLDER}}/*


# Build uberjar file (as an application)
build:
    @just _cmdprint "Building uberjar...\n"
    @mkdir -p target
    clojure -X:uberjar :jar {{TARGET_FOLDER}}/{{ARTIFACT_ID}}-{{VERSION_ID}}.jar :group-id {{GROUP_ID}} :artifact-id {{ARTIFACT_ID}} :version '"{{VERSION_ID}}"'


# Install uberjar locally (requires the pom.xml file)
install:
    @just _cmdprint "Installing uberjar file to local .m2 repository...\n"
    clojure -X:install :installer :local :artifact '"{{TARGET_FOLDER}}/{{ARTIFACT_ID}}-{{VERSION_ID}}.jar"'


# Deploy uberjar file to remote repository (stub)
deploy:
    @just _cmdprint "Deploying uberjar file is not implemented (stub). \n"


# Run application
run:
    @just _cmdprint "Running an application...\n"
    @clojure -M:run


# Run Clojure repl
repl:
    @just _cmdprint "Running Clojure repl...\n"
    @clojure -M:repl


# Compile java sources (if any)
javac src-java-folder='src-java' target-folder='target/classes' compiler-options='["-target" "1.8" "-source" "1.8" "-Xlint:-options"]':
    @just _cmdprint "Compiling java sources from '{{src-java-folder}}' to '{{target-folder}}' using compiler options: '{{compiler-options}}'...\n"
    @clojure -M:javac --main javac {{src-java-folder}} '{{target-folder}}' '{{compiler-options}}'

# Compile clojure code (AOT)
compile compile-path='target/classes': javac
    @just _cmdprint "Compiling clojure code... \n"
    clojure -M:compile -e "(require,'badigeon.compile)(badigeon.compile/compile,'{{GROUP_ID}}.{{ARTIFACT_ID}}.core,{:compile-path,\"{{compile-path}}\"})"

# Build thin JAR file for application
jar: compile
    @just _cmdprint "Building thin JAR file for application...\n"
    @mkdir -p target
    clojure -X:jar :jar {{TARGET_FOLDER}}/{{ARTIFACT_ID}}-{{VERSION_ID}}.jar :group-id {{GROUP_ID}} :artifact-id {{ARTIFACT_ID}} :version '"{{VERSION_ID}}"'


# Check for outdated dependencies
outdated:
    @just _cmdprint "Checking for outdated dependencies...\n"
    @clojure -M:outdated --exclude=org.clojure/tools.deps.alpha


# Run tests
test:
    @just _cmdprint "Running tests...\n"
    @clojure -M:test


# Format source code
format:
    @just _cmdprint "Formatting source code...\n"
    @cljstyle fix


# Lint source code
lint:
	@just _cmdprint "Linting source code...\n"
	clj-kondo --parallel --lint src:test/src:dev/src
	cljstyle check


#  Bump version artifact in `version_id` file, level may be one of: major, minor, patch, alpha, beta, rc, release.
bump level='patch' value='':
    @just _cmdprint "Bumping version artifact: {{VERSION_ID}} at level {{level}} in file 'version_id'...\n"
    @bb -f scripts/bump-semver.clj {{VERSION_ID}} {{level}} {{value}} > version_id
    @just _cprint '{{YELLOW_COLOR}}' "New version artifact: `cat version_id`\n"

STANDALONE-JVM-PARAMS := "-Xmx1g"

# Create a standalone application with bundled JDK (using jlink, JDK 9+)
standalone: build
    @just _cmdprint "Creating a standalone application with bundled JDK...\n"
    @bb -e '(if (nil? (fs/which "jlink")) (do (println "jlink is not installed. Please, install JDK jmod package.\n") (System/exit 1)) (System/exit 0)))'
    @rm -rf ./{{TARGET_FOLDER}}/{{ARTIFACT_ID}}-{{VERSION_ID}}
    jlink --output {{TARGET_FOLDER}}/{{ARTIFACT_ID}}-{{VERSION_ID}} --add-modules java.sql,java.management,jdk.management,java.desktop,java.naming,jdk.unsupported --strip-debug --compress 2 --no-header-files --no-man-pages
    cp {{TARGET_FOLDER}}/{{ARTIFACT_ID}}-{{VERSION_ID}}.jar {{TARGET_FOLDER}}/{{ARTIFACT_ID}}-{{VERSION_ID}}/lib/
    @printf "#!/bin/sh\n\nbin/java {{STANDALONE-JVM-PARAMS}} -cp .:./lib/* {{GROUP_ID}}.{{ARTIFACT_ID}}.core" > {{TARGET_FOLDER}}/{{ARTIFACT_ID}}-{{VERSION_ID}}/start.sh
    @chmod +x {{TARGET_FOLDER}}/{{ARTIFACT_ID}}-{{VERSION_ID}}/start.sh
    cd {{TARGET_FOLDER}} && tar cvfz {{ARTIFACT_ID}}-{{VERSION_ID}}.tar.gz {{ARTIFACT_ID}}-{{VERSION_ID}}/

