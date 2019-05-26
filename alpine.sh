#!/bin/sh 
apk update
apk add git curl make gcc linux-headers chicken vim tmux
tmux
tmux split-window -v