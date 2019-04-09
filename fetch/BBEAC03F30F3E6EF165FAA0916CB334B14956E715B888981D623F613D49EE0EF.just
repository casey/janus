#!/usr/bin/env bash

if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then # If being sourced
  set -euE
fi

source "${VSI_COMMON_DIR}/linux/just_env" "$(dirname "${BASH_SOURCE[0]}")"/vkm.env
cd "${VKM_CWD}"

# plugins
source "${VSI_COMMON_DIR}/linux/docker_functions.bsh"
source "${VSI_COMMON_DIR}/linux/just_docker_functions.bsh"
source "${VSI_COMMON_DIR}/linux/just_git_functions.bsh"

# main function
function caseify()
{
  local just_arg=$1
  shift 1

  case ${just_arg} in

    ### Docker build tasks
    build) # Build all necessary docker images
      if [ "$#" -gt "0" ]; then
        Docker-compose "${just_arg}" ${@+"${@}"}
        extra_args+=$#
      else
        (justify build_recipes gosu tini vsi ninja cmake pipenv)
        Docker-compose build
      fi
      ;;

    ### Run tasks
    run_vkm) # Start a container using the vkm image
      Just-docker-compose run vkm ${@+"${@}"}
      extra_args+=$#
      ;;
    run_compiler) # Start a container using the compiler image
      Just-docker-compose run compiler ${@+"${@}"}
      extra_args+=$#
      ;;

    ### Code compilation
    compile) # Build the source code
      Just-docker-compose run compiler compile
      ;;

    ### Bash tasks (complex bash scripts that run within the Just environment)
    truth) # Run ground truth routine
      (source "${VKM_CWD}/scripts/task.bsh" truth "${@}")
      extra_args+=$#
      ;;
    metrics) # Run metrics routine
      (source "${VKM_CWD}/scripts/task.bsh" metrics "${@}")
      extra_args+=$#
      ;;


    ### Environment synchronize
    setup) # Run any special command to set up the environment for the first \
      # time after checking out the repo. Usually population of volumes/databases \
      # go here.
      (justify _sync)
      ;;
    sync) # Synchronize the many aspects of the project when new code changes \
          # are applied e.g. after "git checkout"
      (justify _sync)
      ;;

    _sync) # Sync the environment so that everyone is on the same version. This
          # includes building the docker images, building the source code, etc.
      (justify git_submodule-update) # For those users who don't remember!
      (justify build)
      (justify clean_compile clean_install)
      (justify compile)
      (justify run vkm pipenv sync)
      ;;

    ### Testing tasks
    test) #Run unit tests
      (justify run vkm test)
      ;;

    ### Clean volumes
    clean_all) # Delete all local volumes
      ask_question "Are you sure you want to remove all local volumes?" n
      (justify clean_compile clean_install clean_venv)
      ;;

    clean_compile) # Delete only build artifacts volume
      (justify _clean_volume "${VKM_BUILD_DIR}")
      ;;
    clean_install) # Delete only install volume
      (justify _clean_volume "${VKM_INSTALL_DIR}")
      ;;
    clean_venv) # delete only venv volume
      (justify _clean_volume "${VKM_VENV_DIR}")
      ;;

    _clean_volume)
      VOLUME_NAME="${COMPOSE_PROJECT_NAME}_${1}"
      if docker volume inspect "${VOLUME_NAME}" &> /dev/null; then
        Docker volume rm "${VOLUME_NAME}"
      else
        echo "${VOLUME_NAME} already removed"
      fi
      extra_args+=$#
      ;;

    ### Debugging tasks
    _source) # source arbitrary script in Just environment
      (source ${@+"${@}"})
      extra_args+=$#
      ;;
    list_volumes) # List docker volumes relevant to your environment
      Docker volume ls --filter "label=com.docker.compose.project=${COMPOSE_PROJECT_NAME}"
      ;;
    printenv) #print local environment variables
      printenv | grep -E "VKM|COMPOSE|MSYS"
      ;;
    *)
      defaultify "${just_arg}" ${@+"${@}"}
      ;;
  esac
}

if ! command -v justify &> /dev/null; then caseify ${@+"${@}"};fi
