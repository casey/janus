#!/usr/bin/env bash

if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then # If being sourced
  set -euE
fi
source "${VSI_COMMON_DIR}/linux/just_env" "$(dirname "${BASH_SOURCE[0]}")"/wine.env
cd "${WINE_CWD}"

# Plugins
source "${VSI_COMMON_DIR}/linux/docker_functions.bsh"
source "${VSI_COMMON_DIR}/linux/just_docker_functions.bsh"
source "${VSI_COMMON_DIR}/linux/just_git_functions.bsh"

# Main function
function caseify()
{
  local just_arg=$1
  shift 1
  case ${just_arg} in
    build) # Build Docker image
      if [ "$#" -gt "0" ]; then
        Docker-compose "${just_arg}" ${@+"${@}"}
        extra_args+=$#
      else
        (justify build_recipes gosu tini-alpine vsi)
        Docker-compose build
      fi
      ;;
    run_wine) # Run wine 1
      Just-docker-compose run wine ${@+"${@}"}
      extra_args+=$#
      ;;

    setup) # Run any special command to set up the environment for the first \
      # time after checking out the repo. Usually population of volumes/databases \
      # go here.
      (justify _sync)
      ;;
    sync) # Synchronize the many aspects of the project when new code changes \
          # are applied e.g. after "git checkout"
      (justify _sync)
      # Add any extra steps run when syncing when not installing
      ;;
    _sync)
      Docker-compose down
      (justify git_submodule-update) # For those users who don't remember!
      (justify build)
      ;;
    clean_all) # Delete all local volumes
      ask_question "Are you sure? This will packages not in Pipfile!" n
      (justify clean wine)
      ;;
    clean_wine) # Delete wine drive
      if docker volume inspect "${COMPOSE_PROJECT_NAME}_wine-prefix" &> /dev/null; then
        Docker volume rm "${COMPOSE_PROJECT_NAME}_wine-prefix"
      else
        echo "${COMPOSE_PROJECT_NAME}_wine-prefix already removed"
      fi

      ;;
    *)
      defaultify "${just_arg}" ${@+"${@}"}
      ;;
  esac
}

if ! command -v justify &> /dev/null; then caseify ${@+"${@}"};fi
