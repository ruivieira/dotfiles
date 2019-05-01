function pyenvcreate () {
	local PROJ_DIR=$(basename $(pwd))
	echo creating pyenv: $fg[green]$PROJ_DIR $reset_color
	pyenv virtualenv 3.6.5 $PROJ_DIR
}

function pyenvactivate () {
	local PROJ_DIR=$(basename $(pwd))
	echo activating pyenv: $fg[green]$PROJ_DIR $reset_color
	pyenv activate $PROJ_DIR
}

function jvm_exists() {
	/usr/libexec/java_home -v$1 >& /dev/null
	if [ $? -eq 0 ]; then
		return 0
	else
		return 1
	fi
}

function syncdropbox() {
	rsync -var --exclude 'target' \
	--exclude '.tox' --exclude '.ipynb_checkpoints' \
	--exclude 'out' \
	--exclude '.mypy_cache' --exclude 'frames' \
	--exclude 'bin' --exclude 'pkg' \
	--exclude 'ml-junkyard/data' \
	~/Sync/code ~/Dropbox/Sync --delete
}

function backup() {
	source ~/.config/restic/credentials.txt
	restic -r $RESTIC_REPOSITORY:$1 --verbose backup $2
}

function docker_nuke() {
	# Delete all containers
	docker rm $(docker ps -a -q)
	# Delete all images
	docker rmi $(docker images -q)
}
