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

# global dot-aliases, allows for e.g. cd ...
alias -g ...='../../'
alias -g ....='../../../'
alias -g .....='../../../../'

### }}}
### function definitions {{{
###

# function precmd() {{{
#   executed before each prompt
function precmd()
{
  export PS1="${BLUE}[%n@%m${GREEN}$(__git_ps1 ' branch:%s')${BLUE}]${RED} %~${NORM} "

  # if the virtualenv environment variable is set, and the RPROMPT does not
  # contain the env token, add the token to the RPROMPT
  if [[ ! -z $VIRTUAL_ENV ]]
  then
    local ENV_HEAD=$(basename $VIRTUAL_ENV)
    local ENV_TOKEN="virtualenv:"

    if [[ ! $RPROMPT == *$ENV_TOKEN* ]]
    then
      # if the RPROMPT did not contain the virtualenv token, simply add it..
      export RPROMPT="$RPROMPT ${BLUE}[${GREEN}$ENV_TOKEN$ENV_HEAD${BLUE}]${NORM}"
    elif [[ ! $RPROMPT == *$ENV_TOKEN$ACTIVE_VIRTUALENV* ]]
    then
      # .. or if it did contain the token, but not with another VIRTUAL_ENV
      # string, replace the tag with an updated one
      export RPROMPT="${RPROMPT/$ENV_TOKEN*]/$ENV_TOKEN$ENV_HEAD]}"
    fi
  fi
}
# }}}

# function useenv() {{{
#   activate the selected virtualenv
#
# arguments:
#   $1 - the name of the virtualenv
function useenv()
{
  # make sure that the project subdir, and the activate script exitst
  test -d $1 || return
  test -f bin/activate

  # source the virtualenv activation script
  . bin/activate

  cd $1

  # exporting this variable causes its value to be appended to RPROMPT
  export ACTIVE_VIRTUALENV=$1
}
# }}}

### }}}

# determine which profile to source based upon hostname
if [[ `hostname` =~ "slaptopen" ]]
then
  source ~/.zsh/profiles/home.zshrc
elif [[ `hostname` =~ "gbguxs[0-9]+" ]]
then
  source ~/.zsh/profiles/work.zshrc
else
  return `error "unknown host"`
fi
