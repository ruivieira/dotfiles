#!/usr/bin/bash

# ENV
EDITOR=/usr/bin/sublime-text
export JAVA_HOME=/opt/jdk1.8.0_45
export JRE_HOME=/opt/jdk1.8.0_45/jre
export PATH=$PATH:/opt/jdk1.8.0_45/bin:/opt/jdk1.8.0_45/jre/bin

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
export HISTIGNORE="*schemasync*:clear:bg:fg:cd:cd -:exit:date:w:* --help" # Colon seperated list of exact commands 

# Go language variables
export GOROOT=$HOME/golang
export GOPATH=$HOME/gocode
export PATH=$PATH:$GOROOT/bin
