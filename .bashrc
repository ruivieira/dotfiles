## Common configuration for all systems (macOS, Linux, etc...)

# aliases

alias 'ls'='ls -a -1 -G -F -h -l'
alias 'cd..'='cd ..'
alias 'dir'='ls'
alias 'eprofile'='$EDITOR ~/.bash_profile'
alias 'rprofile'='source ~/.bash_profile'
alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
alias '..'='cd ..'
# LS_COLORS
LS_COLORS='*.py=31:*.pyc=90:*.db=93:*.bat=31:*.txt=93'

export LS_COLORS

# pyenv
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
eval "$(pyenv init -)"


source .bash_profile

# jEnv path
export PATH=$PATH:$HOME/.jenv/bin

# Rust path
export PATH=$PATH:$HOME/.cargo/bin

# GraalVM binaries
export GRAALVM=/opt/graalvm

# Poetry
export PATH=$PATH:$HOME/.poetry/bin