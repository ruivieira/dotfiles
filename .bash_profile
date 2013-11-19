#!/usr/bin/bash

# ENV
EDITOR=/usr/bin/sublime-text
export JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-amd64

alias 'ls'='ls --time-style=+"%Y-%m-%d %H:%M:%S" -a -1 -o --color -F -h -l'
alias 'cd..'='cd ..'
alias 'dir'='ls'
alias 'eprofile'='$EDITOR ~/.bash_profile'
alias 'rprofile'='source ~/.bash_profile'
alias 'java'=$JAVA_HOME/bin/java
alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
alias '..'='cd ..'
# LS_COLORS
LS_COLORS='*.py=31:*.pyc=90:*.db=93:*.bat=31:*.txt=93'

export LS_COLORS

# cd to a python module directory
cdp () {
    cd "$(python -c "import os.path as _, ${1}; \
	print _.dirname(_.realpath(${1}.__file__[:-1]))"
)"
}

export PYTHONSTARTUP=~/.pythonrc

# ignore commands on the history that might contain passwords
export HISTIGNORE="*schemasync*"

# Go language variables
export GOROOT=$HOME/golang
export PATH=$PATH:$GOROOT/bin

