### .zshrc
###   - sourced for interactive shells
###

### }}}
### modules {{{
###

# source the common functions
source ~/.zsh/lib/common.zsh

# initialize the completion system
autoload -U compinit
compinit

# add git completion
source ~/.zsh/completion/_git

autoload -U colors
colors


### }}}
### general settings {{{
###

export PAGER="/bin/less -s"
export EDITOR="vim"

# history settings
HISTFILE=~/.zshhistory
HISTSIZE=3000
SAVEHIST=3000

# VI settings
export EXINIT="set ai sm sw=2 sts=2 bs=2 showmode ruler guicursor=a:blinkon0"

# use vi keybindings
bindkey -v

# set the DISPLAY variable automatically, using the IP address from SSH_CONNECTION
export DISPLAY="`echo $SSH_CONNECTION | awk '{print $1}'`:0.0"

export LSOPT="--color=auto"
export LS_COLORS='ow=01;35:di=01;35'

#export PS1="${BLUE}[%n@%m]${RED} %~${NORM} "
export RPROMPT="${%}[%?]%{%}"

### }}}
### color definitions {{{
###

BLACK="%{"$'\033[01;30m'"%}"
GREEN="%{"$'\033[01;32m'"%}"
RED="%{"$'\033[01;31m'"%}"
YELLOW="%{"$'\033[01;33m'"%}"
BLUE="%{"$'\033[01;34m'"%}"
BOLD="%{"$'\033[01;39m'"%}"
NORM="%{"$'\033[00m'"%}"


### }}}
### aliases {{{
###

alias ls='ls -AF --color=auto'
alias grep='grep --color=auto'
alias vim="vim -X"
alias view="vim -R"


### }}}
### function definitions {{{
###

# function precmd() {{{
#   executed before each prompt
function precmd()
{
  export PS1="${BLUE}[%n@%m${GREEN}$(__git_ps1 ' branch:%s')${BLUE}]${RED} %~${NORM} "
}
# }}}


### }}}

# determine which profile to source based upon hostname
if [[ `hostname` =~ "slaptopen" ]]
then
  source $HOME/.zsh/home.zshrc
elif [[ `hostname` =~ "gbguxs[0-9]+" ]]
then
  source $HOME/.zsh/work.zshrc
else
  return `error "unknown host"`
fi
