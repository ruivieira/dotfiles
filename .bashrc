# aliases

alias 'ls'='ls -a -1 -o --color -F -h -l'
alias 'cd..'='cd ..'
alias 'dir'='ls'
alias 'eprofile'='$EDITOR ~/.bash_profile'
alias 'rprofile'='source ~/.bash_profile'
alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
alias '..'='cd ..'
# LS_COLORS
LS_COLORS='*.py=31:*.pyc=90:*.db=93:*.bat=31:*.txt=93'

export LS_COLORS

# go path
export GOPATH=$HOME/code/go

# pyenv
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

source .bash_profile

# go binaries
export PATH=$PATH:$GOPATH/bin

# GraalVM binaries
export GRAALVM=/opt/graalvm