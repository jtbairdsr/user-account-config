# ==================================================================================================================== #
#                                                       dc plugin                                                      #
# -------------------------------------------------------------------------------------------------------------------- #
#                                  provides a list of docker-compose shortcut commands                                 #
# ==================================================================================================================== #

dc-start () {
if [ -z "$1" ]; then
	echo 'requrires a process name...'
	echo -e "\nUsage:\t$0 <process_name>"
	return 1
fi
#  shellcheck disable=SC2086,SC2048
docker-compose -f "${DOCKER_COMPOSE_FILE:-docker-compose.yml}" up -d $*
}

dc-rs () {
if [ -z "$1" ]; then
	echo 'requrires a process name...'
	echo -e "\nUsage:\t$0 <process_name>"
	return 1
fi
#  shellcheck disable=SC2086,SC2048
docker-compose -f "${DOCKER_COMPOSE_FILE:-docker-compose.yml}" stop $* || return
docker-compose -f "${DOCKER_COMPOSE_FILE:-docker-compose.yml}" up --remove-orphans -d $*
}

dc-rsf () {
if [ -z "$1" ]; then
	echo 'requrires a process name...'
	echo -e "\nUsage:\t$0 <process_name>"
	return 1
fi
#  shellcheck disable=SC2086,SC2048
docker-compose -f "${DOCKER_COMPOSE_FILE:-docker-compose.yml}" stop $* || return
docker-compose -f "${DOCKER_COMPOSE_FILE:-docker-compose.yml}" up --remove-orphans $*
}

dc-rm () {
if [ -z "$1" ]; then
	echo 'requrires a process name...'
	echo -e "\nUsage:\t$0 <process_name>"
	return 1
fi
#  shellcheck disable=SC2086,SC2048
docker-compose -f "${DOCKER_COMPOSE_FILE:-docker-compose.yml}" rm $*
}

dc-build () {
if [ -z "$1" ]; then
	echo 'requrires a process name...'
	echo -e "\nUsage:\t$0 <process_name>"
	return 1
fi
#  shellcheck disable=SC2086,SC2048
docker-compose -f "${DOCKER_COMPOSE_FILE:-docker-compose.yml}" build $*
}

dc-stop () {
if [ -z "$1" ]; then
	echo 'requrires a process name...'
	echo -e "\nUsage:\t$0 <process_name>"
	return 1
fi
#  shellcheck disable=SC2086,SC2048
docker-compose -f "${DOCKER_COMPOSE_FILE:-docker-compose.yml}" stop $*
}

dc-exec () {
if [ -z "$1" ]; then
	echo 'requrires a process name...'
	echo -e "\nUsage:\t$0 <process_name>"
	return 1
fi
docker-compose -f "${DOCKER_COMPOSE_FILE:-docker-compose.yml}" exec "$1" sh -o vi
}

dc-execb () {
if [ -z "$1" ]; then
	echo 'requrires a process name...'
	echo -e "\nUsage:\t$0 <process_name>"
	return 1
fi
docker-compose -f "${DOCKER_COMPOSE_FILE:-docker-compose.yml}" exec "$1" bash -o vi
}

dc-logs () {
if [ -z "$1" ]; then
	echo 'requrires a process name...'
	echo -e "\nUsage:\t$0 <process_name>"
	return 1
fi
#  shellcheck disable=SC2086,SC2048
docker-compose -f "${DOCKER_COMPOSE_FILE:-docker-compose.yml}" logs $*
}
