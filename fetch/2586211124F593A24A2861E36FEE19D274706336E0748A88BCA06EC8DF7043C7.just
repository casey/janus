#!/usr/bin/env bash

if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then #If being sourced
  set -euE
fi

source "$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd)/wrap"
cd "${WINE_MSYS64_CWD}"

source "${JUST_DIR}/docker_functions.bsh"

DOCKER_COMPOSE_SERVICES=($(docker_compose_service_names "${WINE_MSYS64_CWD}/docker-compose.yml"))

function caseify()
{
  local just_arg=$1
  shift 1
  case ${just_arg} in
    #build_{DOCKER_COMPOSE_SERVICES}) # Build docker image
    build_*)
      Docker-compose build "${just_arg#*_}"
      ;;
    build) # Build Docker image
      Docker-compose build
      ;;

    #run_{DOCKER_COMPOSE_SERVICES}) # Run msys2 in wine using
    run_*)
      Just-docker-compose run \
        -e USER_ID="${WINE_MSYS64_UID}" \
        -e GROUP_ID="$(id -g)" \
        "${just_arg#*_}" ${@+"${@}"}
      extra_args+=$#
      ;;
    volume_clean) # Stop all containers and remove all of the docker volumes
      Docker-compose down -v
      ;;
    *)
      defaultify "${just_arg}" ${@+"${@}"}
      ;;
  esac
}

if ! command -v justify &> /dev/null; then caseify ${@+"${@}"};fi
