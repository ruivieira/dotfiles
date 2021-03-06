GREEN="\033[1;32m"
NOCOLOR="\033[0m"

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

function rsync_net_backup() {
	cd ~/Sync/
	local LOG_FILE="/Users/$USER/tmp/rsyncnet.log"
	touch $LOG_FILE
	echo BEGIN `date` >> ${LOG_FILE}
	echo -e "${GREEN}Sync code folders${NOCOLOR}"
	rsync -avH --exclude-from='.stignore' ~/Sync/code rsyncnet: >> ${LOG_FILE}
	echo -e "${GREEN}Sync journal folder${NOCOLOR}"
	rsync -avH --exclude-from='.stignore' ~/Library/Containers/co.noteplan.NotePlan3/Data/Library/Application\ Support/co.noteplan.NotePlan3/ rsyncnet:wiki >> ${LOG_FILE}
	echo END `date` >> ${LOG_FILE}
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

function restic_backup() {
	echo -e "${GREEN}Backing up code${NOCOLOR}"
	 restic -r b2:${B2_RESTIC_BUCKET}:/ --verbose backup ~/Dropbox/code/backup/code --exclude-file="${HOME}/Sync/.stignore"
	 echo -e "${GREEN}Backing up documents${NOCOLOR}"
	 restic -r b2:${B2_RESTIC_BUCKET}:/ --verbose backup ~/Sync/documents --exclude-file="${HOME}/Sync/.stignore"
	 echo -e "${GREEN}Backing up sites${NOCOLOR}"
	 restic -r b2:${B2_RESTIC_BUCKET}:/ --verbose backup ~/Sync/sites --exclude-file="${HOME}/Sync/.stignore"
	 echo -e "${GREEN}Backing up wiki${NOCOLOR}"
	 restic -r b2:${B2_RESTIC_BUCKET}:/ --verbose backup ~/Dropbox/wiki --exclude-file="${HOME}/Sync/.stignore"
	 echo -e "${GREEN}Backing up Joplin${NOCOLOR}"
	 restic -r b2:${B2_RESTIC_BUCKET}:/ --verbose backup ~/.config/joplin-desktop \
	 	--exclude="cache" --exclude="log-autoupdater.txt" --exclude="log-clipper.txt" --exclude="log.txt" --exclude="tmp"
}
