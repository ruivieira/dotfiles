# aliases

alias 'ls'='ls -a -1 -o -color -F -h -l'
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

source .bash_profile

# added by Anaconda 2.3.0 installer
export PATH="/home/ruivieira/anaconda/bin:$PATH"

# added by Anaconda3 2.3.0 installer
export PATH="/home/ruivieira/anaconda3/bin:$PATH"
