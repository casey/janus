#!/usr/bin/env bash

source "${VSI_COMMON_DIR}/linux/just_env" "$(dirname "${BASH_SOURCE[0]}")"/'just'.env

# Plugins
source "${VSI_COMMON_DIR}/linux/docker_functions.bsh"
source "${VSI_COMMON_DIR}/linux/just_docker_functions.bsh"
source "${VSI_COMMON_DIR}/linux/just_git_functions.bsh"
source "${VSI_COMMON_DIR}/linux/colors.bsh"

cd "${JUST_CWD}"

# Main function
function caseify()
{
  local just_arg=$1
  shift 1
  case ${just_arg} in
    build) # Build Docker image
      if [ "$#" -gt "0" ]; then
        Docker-compose "${just_arg}" ${@+"${@}"}
        extra_args=$#
      else
        (justify build_recipes vsi gosu)
        Docker-compose build
      fi
      ;;

    build_local) # Build local environment (for testing)
      mkdir -p "${JUST_CWD}/build"
      pushd "${JUST_CWD}/build"
        curl -LO "https://github.com/megastep/makeself/archive/${JUST_MAKESELF_VERSION}/makeself.tar.gz"
        tar xf makeself.tar.gz --strip-components=1; \
        rm makeself.tar.gz

        sed '1,/^while true/s|^while true|while false|; 1,/^quiet="n"/s|^quiet="n"|quiet="y"|' "${JUST_CWD}/build/makeself-header.sh" > "${JUST_CWD}/build/makeself-header_just.sh"
      popd &> /dev/null
      ;;

    run_make) # Run makeself
      Just-docker-compose run makeself ${@+"${@}"}
      extra_args=$#
      ;;

    compile_make) # Compile the sh binary
      Just-docker-compose run makeself
      ;;
    compile_local) # Compile the binary locally (for testing)
      mkdir -p "${JUST_CWD}/dist"
      ${DRYRUN} "${JUST_CWD}/build/makeself.sh" --tar-extra "--exclude=.git --exclude=docs ../.juste_wrapper" --noprogress --nomd5 --nocrc --nox11 --keep-umask --header "${JUST_CWD}/build/makeself-header_just.sh" vsi_common/ "${JUST_CWD}/dist/juste" juste_label ./.juste_wrapper
      ;;
    compile_darwin) # Compile the binary locally (for testing on darwin)
      mkdir -p "${JUST_CWD}/dist"
      cp "${JUST_CWD}/.juste_wrapper" "${JUST_CWD}/vsi_common/"
      ${DRYRUN} "${JUST_CWD}/build/makeself.sh" --tar-extra "--exclude=.git --exclude=docs" --noprogress --nomd5 --nocrc --nox11 --keep-umask --header "${JUST_CWD}/build/makeself-header_just.sh" vsi_common/ "${JUST_CWD}/dist/juste" juste_label ./.juste_wrapper
      rm "${JUST_CWD}/vsi_common/.juste_wrapper"
      ;;

    sync) # Synchronize the many aspects of the project when new code changes \
          # are applied e.g. after "git checkout"
      justify _sync
      # Add any extra steps run when syncing when not installing
      ;;
    _sync)
      Docker-compose down
      if [ ! -e "${JUST_CWD}/.just_synced" ]; then
        # Add any commands here, like initializing a database, etc... that need
        # to be run the first time sync is run.
        touch "${JUST_CWD}/.just_synced"
      fi

      justify git_submodule-update # For those users who don't remember!
      justify build
      ;;
    clean) # Remove all binary artifacts
      if [ -x "${JUST_CWD}/dist" ]; then
        rm -r "${JUST_CWD}/dist"
      fi
      if [ -x "${JUST_CWD}/build" ]; then
        rm -r "${JUST_CWD}/build"
      fi
      ;;
    ## upload_release) # Upload a new release to github - $1 - release name
    #   ${DRYRUN} hub release create -a "${JUST_CWD}/juste" "${1}"
    #   extra_args=1
    #   ;;

    release) # Stamp a new release. $1 - release version (e.g. "0.0.1")
      local version=$1

      if ! git diff-index --quiet HEAD &> /dev/null; then
        echo "${RED}Repo is dirty${NC}, please commit uncommited changes"
        exit 1
      fi

      if [ "$(git rev-parse --abbrev-ref HEAD)" != "master" ]; then
        echo "${RED}Current just branch is not master${NC}, please fix and try again"
        exit 1
      fi

      # TODO: Make BSD compatible
      sed -i 's|export JUST_VERSION=.*|export JUST_VERSION='"${version}"'|' vsi_common/linux/just_common.bsh

      pushd vsi_common &> /dev/null
        if [ "$(git rev-parse --abbrev-ref HEAD)" != "master" ]; then
          echo "${RED}Current vsi_common branch is not master${NC}, please fix and try again"
          exit 1
        fi

        git add linux/just_common.bsh
        git commit -m "Just $version" || :
        git push origin master
        git tag "just_${version}"

        echo "Waiting for CI to pass..."
        local rv=2
        while [ "${rv}" = "2" ]; do
          echo -n .
          sleep 10
          rv=0
          hub ci-status "$(git rev-parse HEAD)" &> /dev/null || rv=$?
        done
        if [ "${rv}" != "0" ]; then
          echo "${RED}CI Tests failed${NC}, please fix and try again"
          exit 1
        fi

        git push origin "just_${version}"
      popd &> /dev/null

      git add vsi_common
      git commit -m "Just ${version}"
      git tag "${version}"
      git push origin master "${version}"

      sed -i 's|export JUST_VERSION=.*|export JUST_VERSION='"${version}+1dev"'|' vsi_common/linux/just_common.bsh
      pushd vsi_common &> /dev/null
        git add linux/just_common.bsh
        git commit -m "Just $version+1dev"
        git push origin master
      popd &> /dev/null

      extra_args=1
      ;;

    test) # Run integration tests
      TESTS_DIR="${JUST_CWD}/tests" "${VSI_COMMON_DIR}/tests/run_tests.bsh" ${@+"${@}"}
      extra_args=$#
      ;;
    *)
      defaultify "${just_arg}" ${@+"${@}"}
      ;;
  esac
}

if ! command -v justify &> /dev/null; then caseify ${@+"${@}"};fi

