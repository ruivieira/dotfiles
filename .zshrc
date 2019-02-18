# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

export ZSH_THEME="sunrise"

# Set to this to use case-sensitive completion
CASE_SENSITIVE="false"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

plugins=(emoji git osx mvn rust oc zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh
source ~/.functions.zsh

# Customize to your needs...
source $HOME/.bashrc

test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh

# jEnv configuration
eval "$(jenv init -)"

###-tns-completion-start-###
if [ -f /Users/ruivieira/.tnsrc ]; then
    source /Users/ruivieira/.tnsrc
fi
###-tns-completion-end-###

# set a more comprehensive format for `time`
TIMEFMT='%J   %U  user %S system %P cpu %*E total'$'\n'\
'avg shared (code):         %X KB'$'\n'\
'avg unshared (data/stack): %D KB'$'\n'\
'total (sum):               %K KB'$'\n'\
'max memory:                %M MB'$'\n'\
'page faults from disk:     %F'$'\n'\
'other page faults:         %R'

PROMPT='$(random_emoji animals)':$PROMPT

ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_DIRTY=" ✗"
ZSH_THEME_GIT_PROMPT_CLEAN=" ✔"

# git editor
EDITOR=/usr/local/bin/nvim

# gitea custom templates location
export GITEA_CUSTOM=/opt/gitea/custom