set shell := ["bash", "-c", "-x"]

# tools bins:
MILL      := 'mill'
#SBT       := 'sbt'
#SEED      := 'seed-jvm'
#BLOOP     := 'bloop'
COURSIER  := 'coursier'
SCALAFMT  := 'scalafmt-jvm'
SCALAFIX  := 'scalafix-jvm'

# tools version required:
MILL_WANT_VERSION := '0.6.1'

clean-compile: prepare clean reload build

prepare:
    ./scripts/check-installed-mill.sh {{MILL_WANT_VERSION}}

reload:
    # generate bsp stuff
    {{MILL}} mill.contrib.BSP/install

    # generate bloop stuff
    {{MILL}} mill.contrib.Bloop/install

    # generate intellij stuff
    {{MILL}} mill.scalalib.GenIdea/idea

# supply a specific TARGET to not build everything
build TARGET='all':
    @if [ "{{TARGET}}" == "all" ]; then \
        echo 'Building all targets...'; \
        {{MILL}} all _._.compile; \
    else \
        echo 'Building only specified target...'; \
        {{MILL}} {{TARGET}}.compile; \
    fi

# supply MODE=all really clean the workspace as if fresh git clone
clean MODE='':
    @echo 'Removing build related artifacts...'
    @rm --recursive --force --verbose build out

    @if [ "{{MODE}}" == "all" ]; then \
        echo 'Removing extra stuff from workspace...'; \
        rm --recursive --force --verbose .scalafix-rules .bloop .idea .idea_modules .bsp; \
    fi

run APP: build
    {{MILL}} {{APP}}.run

check-format TARGET='all':
    # command line tool.
    {{SCALAFMT}} --git true --list --check --stdout bin lib

    # mill scalafmt integration. OK, it works, but completely sucks since I can't
    # use command line options to show on the cli what files are wrong!!!
    # just says good or not -.-".

    #@if [ "{{TARGET}}" == "all" ]; then \
    #    {{MILL}} all _.checkFormat; \
    #else \
    #    {{MILL}} {{TARGET}}.checkFormat; \
    #fi

format TARGET='all':
    @if [ "{{TARGET}}" == "all" ]; then \
        {{MILL}} all _._.reformat; \
    else \
        {{MILL}} {{TARGET}}.reformat; \
    fi

check-lint:
    #!/usr/bin/env bash
    TOOL_CLASSPATH="$(
        {{COURSIER}} fetch --cache .scalafix-rules \
            com.github.vovapolu:scaluzzi_2.12:0.1.4.1 \
            com.nequissimus::sort-imports:0.3.2 \
            -p
    )"

    {{SCALAFIX}} --tool-classpath="$TOOL_CLASSPATH" --auto-classpath --check --stdout bin lib

check-updates:
    {{MILL}} mill.scalalib.Dependency/updates
