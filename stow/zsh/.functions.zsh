GREEN="\033[1;32m"
YELLOW="\033[1;93m"
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

function prepare_backup() {
	cd ~/Sync/
	echo -e "${GREEN}Sync code folders${NOCOLOR}"
	rsync -avh --exclude-from='.stignore' --delete  ~/Sync/code ~/Dropbox/code/backup/

    echo -e "${GREEN}Sync notes folders${NOCOLOR}"
	rsync -avh --exclude-from='.stignore' --delete  ~/Sync/notes ~/Dropbox/notes/

    echo -e "${GREEN}Sync epubs folder${NOCOLOR}"
	rsync -avh --exclude-from='.stignore' --delete  ~/Sync/documents/books/epubs/ ~/Dropbox/Documents/Books/eBooks/
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

function kopia_wasabi_connect() {
	echo -e "${GREEN}[kopia]${NOCOLOR} connecting to repository ${YELLOW}Wasabi:$WASABI_KOPIA_BUCKET${NOCOLOR}"
	kopia repository connect s3 \
		--bucket=$WASABI_KOPIA_BUCKET \
		--access-key=$WASABI_KOPIA_ACCESS_KEY \
		--secret-access-key=$WASABI_KOPIA_SECRET_KEY \
		--endpoint=$WASABI_KOPIA_ENDPOINT \
		--password=$KOPIA_PASSWORD
}

function kopia_b2_connect() {
	echo -e "${GREEN}[kopia]${NOCOLOR} connecting to repository ${YELLOW}B2:$B2_KOPIA_BUCKET${NOCOLOR}"
	kopia repository connect b2 \
		--bucket=$B2_KOPIA_BUCKET \
		--key-id=$B2_KOPIA_ACCESS_KEY \
		--key=$B2_KOPIA_SECRET_KEY \
		--password=$KOPIA_PASSWORD
}

function kopia_local_connect() {
	echo -e "${GREEN}[kopia]${NOCOLOR} connecting to ${YELLOW}local volume${NOCOLOR}"
	kopia repository connect filesystem --path=/Volumes/Backup/backup \
		--password=$KOPIA_PASSWORD
}

function kopia_backup() {
	local CURRENT_REPO=$(kopia repository status | awk 'NR==3' | cut -c 36-)

	sources=(~/Sync/code ~/Sync/documents ~/Sync/sites ~/notes ~/Documents/Rack2)

	for s in $sources; do
	    echo -e "${GREEN}[kopia]${NOCOLOR} Backing up $s to ${YELLOW}$CURRENT_REPO${NOCOLOR}"
		kopia snapshot create ${s}
	done
}


function knitmd {
	Rscript -e "library(knitr); knit('$1')"
}

function syncthing_conflicts {
	find $1 -name "*.sync-conflict*"
}

function syncthing_conflicts_delete {
	find "$1" -name "*.sync-conflict*" -delete
}

function notes_move {
	mv ~/Downloads/obsidian/*.md ~/notes/pages/backlog
	trimage -d ~/Downloads/obsidian/images
	mv ~/Downloads/obsidian/images/* ~/notes/pages/backlog/images
}
