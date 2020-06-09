set shell := ["bash", "-c"]

# tools bins
SEED      := 'seed-jvm'
COURSIER  := 'coursier'
SCALAFMT  := 'scalafmt-jvm'
SCALAFIX  := 'scalafix-jvm'

TARGETS_ALL := 'protocol server client'



### begin TASKS ###

clean-compile: clean reload build

reload:
    {{SEED}} bloop

# supply a specific TARGET to not build everything
build TARGET='all':
    @if [ {{TARGET}} == all ]; then \
        echo 'Building all targets...'; \
        {{SEED}} build {{TARGETS_ALL}}; \
    else \
        echo 'Building only specified target...'; \
        {{SEED}} build {{TARGET}}; \
    fi

# supply MODE=all really clean the workspace as if fresh git clone
clean MODE='':
    @echo 'Removing build related artifacts...'
    @rm --recursive --force --verbose build out target .target

    @if [ "{{MODE}}" == "all" ]; then \
        echo 'Removing extra stuff from workspace...'; \
        rm --recursive --force --verbose .bloop .idea .idea_modules .bsp .metals .scalafix-rules/*; \
    fi

run APP: build
    {{SEED}} run {{APP}}

### end TASKS ###



### begin SOURCE CHANGING ###
#format TARGET='all':
#    @if [ "{{TARGET}}" == "all" ]; then \
#        {{SBT}} scalafmt; \
#    else \
#        {{SBT}} "{{TARGET}} / scalafmt"; \
#    fi

#fix TARGET='all':
#    @if [ "{{TARGET}}" == "all" ]; then \
#        {{SBT}} "scalafix"; \
#    else \
#        {{SBT}} "{{TARGET}} / scalafix"; \
#    fi


### end SOURCE CHANGING ###



### begin CHECKING / LINTING ###

check-format:
    {{SCALAFMT}} --git true --list --test --stdout

check-fix: build
    #!/usr/bin/env bash
    TOOL_CLASSPATH="$(
        {{COURSIER}} fetch --cache .scalafix-rules \
            com.github.vovapolu:scaluzzi_2.12:0.1.7 \
            com.github.liancheng:organize-imports_2.12:0.2.1 \
            -p
    )"

    # toml comes from toml-cli installed with rust's cargo
    SCALA_VERSION="$(
        #toml get build.toml project.scalaVersion
        cat build.toml | \
            grep scalaVersion | \
            sed -n 's|.*"\(.*\)".*|\1|p'
    )"

    #SCALAC_OPTIONS="$(
    #    toml get build.toml project.scalaOptions | \
    #        sed -n 's|\[\(.*\).*\]|\1|p' | \
    #        sed -n 's|,| |gp'
    #)"

    #echo $TOOL_CLASSPATH
    #echo $SCALA_VERSION
    #echo $SCALAC_OPTIONS

    {{SCALAFIX}} --tool-classpath "$TOOL_CLASSPATH" \
        --auto-classpath \
        --scala-version "$SCALA_VERSION" \
        --scalac-options "-Ywarn-unused" \
        #--scalac-options "$SCALAC_OPTIONS" \
        --check \
        --verbose \
        --stdout

check-updates:
    {{SEED}} update

### end CHECKING / LINTING ###
