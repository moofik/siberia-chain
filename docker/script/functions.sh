#!/usr/bin/env bash

DIR=$(readlink -e $(dirname $0))
SUDO_CMD=$(test -w /var/run/docker.sock || echo sudo)
PROJECT_DIR="/brainpower"
COMPOSER_HOME=${COMPOSER_HOME:-${DIR}/volumes/composer}

php() {
    if [[ ! -d ${COMPOSER_HOME} ]]; then
        mkdir -p ${COMPOSER_HOME}
    fi

    ${SUDO_CMD} docker run \
        -it \
        --rm \
        -v ${COMPOSER_HOME}:${HOME}/.composer \
        -v ${HOME}/.ssh:${HOME}/.ssh \
        -v ${DIR}/../backend:${PROJECT_DIR} \
        -v ${DIR}/volumes/data:/opt/data \
        -v ${DIR}/build/php-cli/php.ini:/etc/php/7.3/cli/php.ini:ro \
        -v /etc/passwd:/etc/passwd:ro \
        -v /etc/group:/etc/group:ro \
        -w ${PROJECT_DIR} \
        -u $(id -u) \
        --network brainpower \
        brainpower/php-cli \
        $@
}

node() {
    if [[ -z "$MOUNT_DIR" ]]; then
        echo -e "${RED}Env variable MOUNT_DIR in undefined.\r\nPlease define env variable before script the same way we do it in the next example:\r\nMOUNT_DIR=frontend npm install${NC}"
        exit 1
    fi

    local base_dir=$(dirname ${DIR})
    local work_dir=$(pwd | sed "s:${base_dir}:${PROJECT_DIR}:")

    if [[ ${work_dir} = $(pwd) ]]; then
        work_dir="${PROJECT_DIR}"
    fi

    ${SUDO_CMD} docker run \
        -it \
        --rm \
        -v ${NPM_HOME}:/.npm \
        -v ${NPM_HOME}:/home/node/.npm \
        -v ${HOME}/.ssh:/.ssh \
        -v ${HOME}/.ssh:/home/node/.ssh \
        -v ${DIR}/../${MOUNT_DIR}:${PROJECT_DIR} \
        -w ${work_dir} \
        -u $(id -u) \
        --network brainpower \
        masterhome/node \
        $@
}

mysql() {
    local base_dir=$(dirname ${DIR})
    local work_dir=$(pwd | sed "s:${base_dir}:${PROJECT_DIR}:")

    if [[ ${work_dir} = $(pwd) ]]; then
        work_dir="${PROJECT_DIR}"
    fi

    ${SUDO_CMD} docker run \
        -it \
        --rm \
        -v ${DIR}/../backend:${PROJECT_DIR} \
        -w ${work_dir} \
        --network brainpower \
        brainpower/mysql \
        "$@"
}
