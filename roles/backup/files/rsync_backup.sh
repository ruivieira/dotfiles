#!/bin/bash
HOME=/Users/rui
cd $HOME/Sync/
rsync -avh --exclude-from=$HOME/Sync/.stignore --delete $HOME/Sync/code $HOME/Dropbox/code/backup/
rsync -avh --exclude-from=$HOME/Sync/.stignore --delete  $HOME/Library/Containers/co.noteplan.NotePlan3/Data/Library/Application\ Support/co.noteplan.NotePlan3/ $HOME/Dropbox/wiki/