function pyenvcreate () {
	local PROJ_DIR=$(basename $(pwd))
	echo creating pyenv: $fg[green]$PROJ_DIR $reset_color
	pyenv virtualenv 3.7.3 $PROJ_DIR
}

function pyenvactivate () {
	local PROJ_DIR=$(basename $(pwd))
	echo activating pyenv: $fg[green]$PROJ_DIR $reset_color
	pyenv activate $PROJ_DIR
}

function pyenvdelete () {
	local PROJ_DIR=$(basename $(pwd))
	echo deleting pyenv: $fg[green]$PROJ_DIR $reset_color
	pyenv virtualenv-delete $PROJ_DIR
}

function jvm_exists() {
	/usr/libexec/java_home -v$1 >& /dev/null
	if [ $? -eq 0 ]; then
		return 0
	else
		return 1
	fi
}

function docker_nuke() {
	# Delete all containers
	docker rm $(docker ps -a -q)
	# Delete all images
	docker rmi $(docker images -q)
}
