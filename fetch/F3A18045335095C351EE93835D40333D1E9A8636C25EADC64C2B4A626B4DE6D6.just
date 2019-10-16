#!/usr/bin/env bash

source "${VSI_COMMON_DIR}/linux/just_env" "$(dirname "${BASH_SOURCE[0]}")"/'terra.env'

# Plugins
source "${VSI_COMMON_DIR}/linux/docker_functions.bsh"
source "${VSI_COMMON_DIR}/linux/just_docker_functions.bsh"
source "${VSI_COMMON_DIR}/linux/just_git_functions.bsh"
source "${VSI_COMMON_DIR}/linux/just_sphinx_functions.bsh"

cd "${TERRA_CWD}"

# Make terra's justfile a plugin if it is not the main Justfile
if [ "${JUSTFILE}" != "${BASH_SOURCE[0]}" ]; then
  JUST_HELP_FILES+=("${BASH_SOURCE[0]}")
else
  # Allow terra to be run as a non-plugin too
  function caseify()
  {
    defaultify ${@+"${@}"}
  }
fi

# Always add this to the list, because of how the caseify above works
JUST_DEFAULTIFY_FUNCTIONS+=(terra_caseify)

function Terra_Pipenv()
{
  if [[ ${TERRA_LOCAL-} == 1 ]]; then
    PIPENV_PIPFILE="${TERRA_CWD}/Pipfile" pipenv ${@+"${@}"} || return $?
  else
    Just-docker-compose -f "${TERRA_CWD}/docker-compose-main.yml" run ${TERRA_PIPENV_IMAGE-terra} pipenv ${@+"${@}"} || return $?
  fi
}

# Main function
function terra_caseify()
{
  local just_arg=$1
  shift 1
  case ${just_arg} in
    --local) # Run terra command locally
      export TERRA_LOCAL=1
      ;;

    # # terra) # Run terra core target
    #   terra_caseify terra_cmd ${@+"${@}"}
    #   # extra_args=$#
    #   ;;

    ### Building docker images ###
    terra_build) # Build Docker image
      if [ "$#" -gt "0" ]; then
        Docker-compose build ${@+"${@}"}
        extra_args=$#
      else
        justify build recipes-auto "${TERRA_CWD}"/docker/*.Dockerfile
        Docker-compose -f "${TERRA_CWD}/docker-compose-main.yml" build
        COMPOSE_FILE="${TERRA_CWD}/docker-compose-main.yml" justify docker-compose clean terra-venv
        justify terra build-services
      fi
      ;;
    terra_build-services) # Build services. Takes arguments that are passed to the \
                    # docker-compose build command, such as "redis"
      Docker-compose -f "${TERRA_CWD}/docker-compose.yml" build ${@+"${@}"}
      extra_args=$#
      ;;

    # terra_build-singular) # Build dockers for import to singularity and push them to registry
    #   justify build recipes-auto "${TERRA_CWD}"/docker/*.Dockerfile
    #   justify terra build-services
    #   for image in "${TERRA_DOCKER_REPO}:redis_${TERRA_USERNAME}"; do
    #     command="$(docker inspect -f '{{json .Config.Cmd}}' ${image})"
    #     entrypoint="$(docker inspect -f '{{json .Config.Entrypoint}}' ${image})"
    #     if [[ ${entrypoint} == null ]]; then
    #       entrypoint=
    #     else
    #       # Remove tini and optional -- argument after it
    #       entrypoint="$(sed -E 's|"[^"]*tini",("--",)?||' <<< "${entrypoint}")"
    #       entrypoint="ENTRYPOINT ${entrypoint}"
    #     fi
    #     if [[ ${command} == null ]]; then
    #       command=
    #     else
    #       command="CMD ${command}"
    #     fi
    #     ( # Quick dockerfile
    #       echo "FROM ${image}";
    #       echo "${entrypoint}";
    #       echo "${command}"
    #     ) |  Docker build -t "${TERRA_LOCAL_DOCKER_REGISTRY}${TERRA_LOCAL_DOCKER_REGISTRY+/}${image}" -
    #     Docker push "${TERRA_LOCAL_DOCKER_REGISTRY}${TERRA_LOCAL_DOCKER_REGISTRY+/}${image}"
    #   done
    #   ;;

    # terra_pull-singular) # Pull images from registry
    #   for image in "${TERRA_DOCKER_REPO}:redis_${TERRA_USERNAME}"; do
    #     SINGULARITY_NOHTTPS=1 singularity build ${image##*:}.simg docker://${TERRA_LOCAL_DOCKER_REGISTRY}/${image}
    #   done
    #   ;;

    terra_build-singular) # Build singularity images
      justify build recipes-auto "${TERRA_CWD}"/docker/*.Dockerfile
      justify terra build-services
      # docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock -v /opt/projects/terra/singularity/nginx:/output --privileged singularityware/docker2singularity:v2.6 mypytest:latest

      for image in "${TERRA_DOCKER_REPO}:redis_${TERRA_USERNAME}"; do
        docker run -it --rm --privileged --entrypoint= \
          -v /var/run/docker.sock:/var/run/docker.sock \
          -v "$(pwd)":/output \
          singularityware/docker2singularity:v2.6 bash -c "
            sed -i 's|echo \"(9/10)|echo \"(8.5/10) Custom script\"; [[ -r \\\${build_sandbox}/.singularity.d/tosingular ]] \\&\\& source \\\${build_sandbox}/.singularity.d/tosingular; &|' /docker2singularity.sh &&
            /docker2singularity.sh \"\${@}\"" bash "${image}"
          #   sed -Ei 's|(chmod.*runscript;)|\1 cp \\\${build_sandbox}/.singularity.d/runscript \\\${build_sandbox}/.singularity.d/startscript|' /docker2singularity.sh &&
          #   /docker2singularity.sh \"\${@}\"" bash "${image}"
      done
      ;;

    terra_run-singular-redis) # Run redis in singularity
      singularity run -e -c --pwd /data redis_${TERRA_USERNAME}.simg
      ;;

    ### Running containers ###
    run) # Run python module/cli in terra
      Terra_Pipenv run python -m ${@+"${@}"}
      extra_args=$#
      ;;
    run_pdb) # Run pdb module/cli in terra
      Terra_Pipenv run python -m pdb -m ${@+"${@}"}
      extra_args=$#
      ;;
    terra_run) # Run command (arguments) in terra
      local rv=0
      Terra_Pipenv run ${@+"${@}"} || rv=$?
      extra_args=$#
      return $rv
      ;;

    terra_run-nopipenv) # Run terra command not in pipenv
      if [[ ${TERRA_LOCAL-} == 1 ]]; then
        ${@+"${@}"}
      else
        Just-docker-compose -f "${TERRA_CWD}/docker-compose-main.yml" run ${terra_service_name-terra} nopipenv ${@+"${@}"} || rv=$?
      fi
      extra_args=$#
      ;;

    run_redis) # Run redis
      Just-docker-compose -f "${TERRA_CWD}/docker-compose.yml" run redis ${@+"${@}"}
      extra_args=$#
      ;;
    run_celery) # Starts a celery worker
      local node_name
      if [[ ${TERRA_LOCAL-} == 1 ]]; then
        node_name="local@%h"
      else
        node_name="docker@%h"
      fi

      Terra_Pipenv run celery -A terra.executor.celery.app worker --loglevel="${TERRA_CELLER_LOG_LEVEL-INFO}" -n "${node_name}"
      ;;

    ### Run Debugging containers ###
    generate-redis-commander-hash) # Generate a redis commander hash
      touch "${TERRA_REDIS_COMMANDER_SECRET_FILE}"
      Docker run -it --rm --mount type=bind,source="$(real_path "${TERRA_REDIS_COMMANDER_SECRET_FILE}")",destination=/hash_file  python:3 sh -c "
        pip install bcrypt
        python -c 'if 1:
          import bcrypt,getpass
          pass1 = getpass.getpass(\"Enter a password: \")
          hash1 = bcrypt.hashpw(pass1.encode(), bcrypt.gensalt(rounds=10))
          with open(\"/hash_file\", \"wb\") as fid:
            fid.write(hash1)
        '
      "
      ;;
    run_redis-commander) # Run redis-commander
      if [ ! -s "${TERRA_REDIS_COMMANDER_SECRET_FILE}" ]; then
        justify generate-redis-commander-hash
      fi
      Docker-compose -f "${TERRA_CWD}/docker-compose-main.yml" run --service-ports redis-commander
      ;;

    ### Deploy command ###
    terra_up) # Start redis (and any other services) in the background.
      Just-docker-compose -f "${TERRA_CWD}/docker-compose.yml" up -d
      ;;
    terra_down) # Stop redis (and any other services) in the background.
      Just-docker-compose -f "${TERRA_CWD}/docker-compose.yml" down
      ;;
    terra_deploy) # Deploy services on a swarm
      Docker-compose -f "${TERRA_CWD}/docker-compose.yml" \
                     -f "${TERRA_CWD}/docker-compose-swarm.yml" config | \
          Docker stack deploy -c - terra
      ;;


    ### Testing ###
    terra_test) # Run unit tests
      source "${VSI_COMMON_DIR}/linux/colors.bsh"
      echo "${YELLOW}Running ${GREEN}python ${YELLOW}Tests${NC}"
      if [[ $# == 0 ]]; then
        # Use bash -c So that TERRA_TERRA_DIR is evaluated correctly inside the environment
        Terra_Pipenv run env TERRA_UNITTEST=1 bash -c 'python -m unittest discover "${TERRA_TERRA_DIR}/terra"'
      else
        Terra_Pipenv run env TERRA_UNITTEST=1 python -m unittest "${@}"
      fi
      extra_args=$#
      ;;
    # Ideas
    terra_coverage) # Run coverage on terra
      pushd "${TERRA_CWD}" >& /dev/null # Not needed because of a cd line above
        Terra_Pipenv run env TERRA_UNITTEST=1 bash -c 'coverage run && coverage report -m'
      popd >& /dev/null # but added this so an app developer would know to add it
      ;;

    # How do I know what error code causes a problem in autopep8? You don't!
    # At least not as far as I can tell.
    terra_pep8) # Check pep8 compliance in ./terra
      echo "Checking for autopep8..."
      if ! Terra_Pipenv run sh -c "command -v autopep8" >& /dev/null; then
        justify terra pipenv sync --dev
      fi

      echo "Running for autopep8..."
      Terra_Pipenv run bash -c 'autopep8 --global-config "${TERRA_TERRA_DIR}/autopep8.ini" --ignore-local-config \
                                "${TERRA_TERRA_DIR}/terra"'
      ;;
    terra_test-pep8) # Run pep8 test
      justify terra pep8
      Terra_Pipenv run bash -c 'flake8 \
                                "${TERRA_TERRA_DIR}/terra"'
      ;;

    ### Syncing ###
    terra_sync) # Synchronize the many aspects of the project when new code changes \
          # are applied e.g. after "git checkout"
      if [ ! -e "${TERRA_CWD}/.just_synced" ]; then
        # Add any commands here, like initializing a database, etc... that need
        # to be run the first time sync is run.
        touch "${TERRA_CWD}/.just_synced"
      fi
      justify git_submodule-update # For those users who don't remember!
      if [[ ${TERRA_LOCAL-} == 1 ]]; then
        COMPOSE_FILE="${TERRA_CWD}/docker-compose-main.yml" justify docker-compose clean terra-venv
        Terra_Pipenv sync
        justify terra build-services
      else
        justify terra build
      fi
      ;;

    terra_pipenv) # Run pipenv commands in Terra's pipenv conatainer. Useful for \
                  # installing/updating pipenv packages into terra
      TERRA_PIPENV_IMAGE=terra_pipenv Terra_Pipenv ${@+"${@}"}
      extra_args=$#
      ;;

    terra_clean-all) # Delete all local volumes
      ask_question "Are you sure? This will remove packages not in Pipfile!" n
      COMPOSE_FILE="${TERRA_CWD}/docker-compose-main.yml" justify docker-compose clean terra-venv
      COMPOSE_FILE="${TERRA_CWD}/docker-compose.yml" justify docker-compose clean terra-redis
      ;;

    ### Other ###
    # command: bash -c "touch /tmp/watchdog; while [ -e /tmp/watchdog ]; do rm /tmp/watchdog; sleep 1000; done"
    # terra_vscode) # Execute vscode magic in a vscode container
    #   local container="$(docker ps -q -f "label=com.docker.compose.service=vscode" -f "label=com.docker.compose.project=${COMPOSE_PROJECT_NAME}")"
    #   if [ -z "${container}" ]; then
    #     Just-docker-compose -f "${C3D_CWD}/docker-compose.yml" up -d vscode
    #     container="$(docker ps -q -f "label=com.docker.compose.service=vscode" -f "label=com.docker.compose.project=${COMPOSE_PROJECT_NAME}")"
    #   fi
    #   local flags=""
    #   if [ -t 0 ]; then
    #     flags="-t"
    #   fi
    #
    #   # Keep the container going for another 1000 seconds and execute command
    #   # specified. $1 is sent first to be $0
    #   docker exec -u user -i ${flags} "${container}" bash -c 'touch /tmp/watchdog; ${@+"${@}"}' # ${@+"${1}"} ${@+"${@}"}
    #
    #   extra_args+=$#
    #   ;;

    terra_ipykernel) # Start a jupyter kernel in runserver. You must have run \
                     # just terra pipenv sync --dev for this to work.
      # Example kernel.json
      # {
      # "display_name": "terra",
      # "argv": [
      #  "python", "-m", "docker_proxy_kernel",
      #  "-f", "{connection_file}",
      #  "--cmd", "['{source dir}/terra/external/vsi_common/linux/just', 'terra', 'ipykernel']"
      # ],
      # "env": {"JUSTFILE": "{source dir}/terra/Justfile"},
      # "language": "python"
      # }
      Just-docker-compose -f "${TERRA_CWD}/docker-compose-main.yml" \
          run -T --service-ports ipykernel \
          pipenv run python -m ipykernel_launcher ${@+"${@}"} > /dev/null
      extra_args=$#
      ;;
    *)
      plugin_not_found=1
      ;;
  esac
  return 0
}

if ! command -v justify &> /dev/null; then caseify ${@+"${@}"};fi
