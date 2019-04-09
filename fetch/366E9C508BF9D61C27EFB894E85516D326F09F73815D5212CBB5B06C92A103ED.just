#!/usr/bin/env bash

source "${VSI_COMMON_DIR}/linux/just_env" "$(dirname "${BASH_SOURCE[0]}")/amanda.env"
cd "${AMANDA_CWD}"

source "${VSI_COMMON_DIR}/linux/docker_functions.bsh"
source "${VSI_COMMON_DIR}/linux/just_docker_functions.bsh"
source "${VSI_COMMON_DIR}/linux/just_git_functions.bsh"

function caseify()
{
  local just_arg=$1
  shift 1
  case ${just_arg} in
    build) # Build everything
      justify build_recipes gosu tini vsi amanda_deb ep
      justify client build
      justify server build server
      ;;
    build_client) # Build the client
      justify build_recipes tini amanda_deb
      justify client build
      ;;
    build_server) # Build the server
      justify build_recipes gosu tini vsi amanda_deb ep
      justify server build server
      ;;
    push) # Push to dockerhub
      justify client push
      justify server push server
      ;;
    dropbox) # Start dropbox daemon
      Docker-compose -f "${AMANDA_CWD}/dropbox.yml" up -d --build --force-recreate
      ;;
    dropbox_status) # Get dropbox daemon status
      Docker-compose -f "${AMANDA_CWD}/dropbox.yml" exec dropbox gosu dropbox /dropbox/dropbox.py status
      ;;
    client) # Run docker compose command for the client. E.g. "client run"
      if [ "$#" = "0" ]; then
        justify client up -d amandad
        justify client logs -f
      else
        if command -v docker1.23 >&/dev/null && [ "$(docker1.23 info 2>/dev/null | sed -n '/^Server Version/{s/Server Version: //p;q}')" == "1.11.2" ]; then
          export COMPOSE_API_VERSION=1.23
          #export COMPOSE_FILE="${AMANDA_CWD}/docker-compose1.yml"
        fi
        Docker-compose "${@}"
        extra_args+=$#
      fi
      ;;
    server) # Run docker compose command for the server
      if [ "$#" = "0" ]; then
        justify server up -d server
      else
        Docker-compose -f "${AMANDA_CWD}/server.yml" "${@}"
        extra_args+=$#
      fi
      ;;

    backup) # Start a backup on the server
      justify server run -d backup
      # justify server logs -f backup
      justify backup logs
      ;;

    backup_logs) # Show the backup logs
      justify server run server tail -n +1 -f "/etc/amanda/persist/${AMANDA_CONFIG_NAME}/log" "/etc/amanda/persist/${AMANDA_CONFIG_NAME}/amdump"
      ;;

    report) # Print last report
      justify server run server amreport "${AMANDA_CONFIG_NAME}"
      ;;

    status) # Get some useful status info on a running backup
      local DOCKER_EXTRA_EXEC_ARGS=(-u amandabackup)
      # 'printf "$(grep -Ei '"'"'^pondering|^  curr level'"'"' /etc/amanda/persist/'"${AMANDA_CONFIG_NAME}"'/amdump | sed -E '"'"'N;s|^(.*)\n(  curr level )([0-9])( nsize )([0-9]*)(.*)|\3 \5 \1\\n\2\3\4\5\6|;p'"'"' | sort -u | sort -gk1,1 -gk2,2nr | sed '"'"'s|^[0-9]* [0-9]* ||'"'"')" | grep --color=always -E '"'"'^|/[^/]*\.\.\.|[0-9]* csize'"'"'
      COMPOSE_FILE="${AMANDA_CWD}/server.yml" COMPOSE_SERVICES="backup" justify docker-compose enter bash -c \
      'amanda_run="$(readlink /etc/amanda/persist/'"${AMANDA_CONFIG_NAME}"'/amdump)"
      ls -larot /holding/hd1/${amanda_run#*amdump.}
      amstatus '"${AMANDA_CONFIG_NAME}"
      ;;
    email_report) # Email last report
      justify server run server amreport "${AMANDA_CONFIG_NAME}" -M "${AMANDA_TO_EMAIL}"
      ;;

    pull-server-ssh) # Pull the server ssh public key
      justify server run server cat /etc/keys/id_rsa.pub > server.pub
      ;;
    pull-client-ssh) # Pull the client ssh public key
      justify client run amandad cat /etc/keys/id_rsa.pub > client.pub
      ;;


    push-client-ssh) # Push the server ssh key to the client
      justify client run amandad bash -c "cat - >> /etc/keys/authorized_keys" < "${AMANDA_CWD}/server.pub"
      ;;
    push-server-ssh) # Push the client ssh key to the server
      # Disable the entrypoint because
      # 1) I don't really need it
      # 2) I need to run as root. Both stdin and authorized_keys are root only
      justify server run --entrypoint= server bash -c "cat - >> /etc/keys/authorized_keys" < "${AMANDA_CWD}/client.pub"
      ;;

    abort) # Abort a backup in progress
      local DOCKER_EXTRA_EXEC_ARGS=(-u amandabackup -it)
      COMPOSE_FILE="${AMANDA_CWD}/server.yml" COMPOSE_SERVICES="backup" justify docker-compose enter amcleanup -k "${AMANDA_CONFIG_NAME}"
      ;;

    cleanup) # Cleanup an interrupted backup
      justify server run server amcleanup "${AMANDA_CONFIG_NAME}"
      ;;

    check) # Test amanda configuration and check which tape is inserted and if
           # it is valid, also tests clients
      justify server run server amcheck "${AMANDA_CONFIG_NAME}" --client-verbose
      ;;

    list-tapes) # List tapes in the tape drive(s) for the current configuration
      justify server run server amtape "${AMANDA_CONFIG_NAME}" show
      ;;

    current-tape) #Display current slot/tape
      justify server run server amtape "${AMANDA_CONFIG_NAME}" current
      ;;

    rewind) # Rewind tape. This should not be part of normal operation
      justify server run server mt -f ${AMANDA_TAPE_DRIVE} rewind
      ;;

    eject) # Eject current tape
      justify server run server mt-st -f ${AMANDA_TAPE_DRIVE} eject
      ;;


    dump-backup) #Use in conjunction with | tar tv, or | tar xv
      justify server run server amrecover ${AMANDA_TAPE_DRIVE} -
      ;;

    print-config) # Print configuration
      justify server run server amadmin "${AMANDA_CONFIG_NAME}" config
      ;;

    recover) # Start interactive recover
      justify client run amandad amrecover "${AMANDA_CONFIG_NAME}"
      ;;

    upload) # Upload amanda configuration to connected docker server
      cd "${AMANDA_CWD}/${AMANDA_CONFIG_NAME}"
      tar zc * | docker run -i --rm -v "amanda_amanda-config":/cp -w /cp alpine tar zx
      ;;


    gpg-suggest-password) # Suggest a good random password
      head -c 48 /dev/urandom | openssl base64
      ;;
    gpg-keys) # Generate new gpg encrypted keys for backup
      justify server run server bash -c '
        x=1; while [ "$x" != "$y" ]; do
          read -rsp "Passphrase: " x; echo
          read -rsp "Confirm: " y; echo
        done
        echo -n "$x" > /etc/keys/.am_passphrase
        chmod 400 /etc/keys/.am_passphrase
        head -c 3120 /dev/urandom | openssl base64 | head -n 66 | tail -n 65 | \
          gpg2 --batch --cipher-algo aes256 --symmetric -a --passphrase-file /etc/keys/.am_passphrase > \
          /etc/amanda/persist/'"${AMANDA_CONFIG_NAME}"'/am_key.gpg'
      ;;
    set-gpg-passphrase) # Set gpg passphrase for when restoring from dropbox backup
      justify server run server bash -c '
        read -rsp "Passphrase: " x; echo
        cat - > /etc/keys/.am_passphrase <<< "${x}"
        chmod 400 /etc/keys/.am_passphrase'
      ;;
    recover) # Start amrecover
      justify client run amandad amrecover "${AMANDA_CONFIG_NAME}"
      ;;
    *)
      defaultify "${just_arg}" ${@+"${@}"}
      ;;
  esac
}

if ! command -v justify &> /dev/null; then caseify ${@+"${@}"};fi
