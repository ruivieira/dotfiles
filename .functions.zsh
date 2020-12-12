function pyenvcreate () {
	local PROJ_DIR=$(basename $(pwd))
	echo creating pyenv: $fg[green]$PROJ_DIR $reset_color
	pyenv virtualenv 3.8.5 $PROJ_DIR
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

function rsync_code_dropbox() {
	cd ~/Sync/
	rsync -avh --exclude-from='.stignore' --delete  ~/Sync/code ~/Dropbox/code/backup/
}

function docker_nuke() {
	# Delete all containers
	docker rm $(docker ps -a -q)
	# Delete all images
	docker rmi $(docker images -q)
}

function borg_backup_code() {
	local archive_name="$(date +%s)"
	borg create --progress --stats --compression zlib ~/Backup::code-${archive_name} ~/Dropbox/code/backup/code
}

function b2_upload_backup() {
	rclone -P sync ~/Backup b2:$B2_BACKUP_BUCKET
}

function restic_backup_code() {
	 restic -r b2:${B2_RESTIC_BUCKET}:/ --verbose backup ~/Dropbox/code/backup/code
}
