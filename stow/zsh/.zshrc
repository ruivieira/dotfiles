# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

ZSH_THEME="gruvbox"
SOLARIZED_THEME="dark"

# Set to this to use case-sensitive completion
CASE_SENSITIVE="false"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"


ROBBY_DIR=${HOME}/Sync/code/robby

alias notes=${ROBBY_DIR}/robby/xontrib/notes.xsh
alias humble=${ROBBY_DIR}/robby/xontrib/humble.xsh

plugins=(emoji git macos mvn rust zsh-autosuggestions history-substring-search zsh-syntax-highlighting zsh-z robby artisan)

source $ZSH/oh-my-zsh.sh

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

export PROMPT='$(random_emoji animals)':$PROMPT

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
