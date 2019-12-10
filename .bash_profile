#!/usr/bin/bash

export JAVA_HOME=/opt/jdk1.8
export JRE_HOME=/opt/jdk1.8/jre
export PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin

# cd to a python module directory
cdp () {
    cd "$(python -c "import os.path as _, ${1}; \
	print _.dirname(_.realpath(${1}.__file__[:-1]))"
)"
}

export PYTHONSTARTUP=~/.pythonrc

# ignore commands on the history that might contain passwords
export HISTIGNORE="*schemasync*:clear:bg:fg:cd:cd -:exit:date:w:* --help" # Colon seperated list of exact commands

# OpenShift Origin
export PATH=$HOME/openshift:$PATH