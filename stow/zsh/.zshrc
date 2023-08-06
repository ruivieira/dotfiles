# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

SOLARIZED_THEME="dark"

# Set to this to use case-sensitive completion
CASE_SENSITIVE="false"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"


ROBBY_DIR=${HOME}/Sync/code/robby

plugins=(emoji git macos mvn rust zsh-autosuggestions history-substring-search zsh-syntax-highlighting zsh-z robot)

source $ZSH/oh-my-zsh.sh
source $HOME/.bash_profile

# load aliases
if [ -f $HOME/.aliasrc ]; then
    source $HOME/.aliasrc
fi

# function
if [ -f $HOME/.functions.zsh ]; then
    source $HOME/.functions.zsh
fi

# set a more comprehensive format for `time`
TIMEFMT='%J   %U  user %S system %P cpu %*E total'$'\n'\
'avg shared (code):         %X KB'$'\n'\
'avg unshared (data/stack): %D KB'$'\n'\
'total (sum):               %K KB'$'\n'\
'max memory:                %M MB'$'\n'\
'page faults from disk:     %F'$'\n'\
'other page faults:         %R'

CURRENT_ANIMAL=$(random_emoji animals)
# export PROMPT='$CURRENT_ANIMAL %{$fg[cyan]%}%~%{$reset_color%} $(git_super_status) '

ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_DIRTY=" ✗"
ZSH_THEME_GIT_PROMPT_CLEAN=" ✔"

# git editor
EDITOR=/usr/local/bin/code

# Deno variables
export DENO_INSTALL=$HOME/.deno
export PATH="$HOME/.nimble/bin:$DENO_INSTALL/bin:$PATH"
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Add Brew to path
export PATH=/usr/local/bin:$PATH

# Stop Kopia checking for updates
export KOPIA_CHECK_FOR_UPDATES=false

# Add CRC to path
export PATH=$HOME/crc:$PATH

# Add JBang to environment
alias j!=jbang
export PATH="$HOME/.jbang/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"

# Python configurations

export WORKON_HOME=$HOME/.virtualenvs

eval "$(starship init zsh)"
export PATH="/usr/local/opt/ruby/bin:$PATH"

PATH="/Users/rui/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/Users/rui/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/rui/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/rui/perl5\""; export PERL_MB_OPT;

