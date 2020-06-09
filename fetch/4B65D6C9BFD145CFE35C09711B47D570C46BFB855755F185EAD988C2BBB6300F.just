# Copyright 2018-2020 Cargill Incorporated
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

splinter_repo := "../splinter"

build: docker-build

copy-docs:
    #!/usr/bin/env sh
    set -e
    if test -f {{splinter_repo}}/VERSION; then
        version=$(cat {{splinter_repo}}/VERSION | awk -F. '{print $1"."$2}')
        # Print the branch of splinter the man pages are from
        splinter_branch=$(cd {{splinter_repo}} && git name-rev --name-only HEAD)
        echo "Splinter repository branch is $splinter_branch"

        # sync man pages from splinter cli and splinterd
        cmd="rsync -r -v {{splinter_repo}}/cli/man/ docs/$version/references/cli"
        echo "\033[1m$cmd\033[0m"
        $cmd

        cmd="rsync -r -v {{splinter_repo}}/splinterd/man/ docs/$version/references/cli"
        echo "\033[1m$cmd\033[0m"
        $cmd

        # Remove any templates that were copied over
        cmd="rm -v docs/$version/references/cli/*.example"
        echo "\033[1m$cmd\033[0m"
        $cmd
    else
        echo "error: {{splinter_repo}}/VERSION was not found, aborting." 1>&2
        exit 1
    fi

docker-build:
    docker build \
        -t splintercommunity/splinter-docs \
        -f ci/website.dockerfile \
        .

docker-lint:
    docker-compose \
        -f docker/compose/run-lint.yaml \
        up \
        --abort-on-container-exit \
        --build \
        lint-splinter-docs

docker-run:
    docker-compose up --build; docker-compose down

lint: docker-lint

run: docker-run
