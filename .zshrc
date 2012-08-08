autoload -U compinit
compinit

source ~/.zsh/completion/_git

function precmd()
{
  export PS1="${BLUE}[%n@%m${GREEN}$(__git_ps1 ' branch:%s')${BLUE}]${RED} %~${NORM} "
}

autoload -U colors
colors

function mkscript()
{
  local readonly INTERPRETER=${2:-/bin/bash -}

  if [[ -z $1 ]]
  then
    echo "error: no script named"
    return 1
  fi

  echo "#!$INTERPRETER" > $1 ; chmod u+x $1
}

######## Custom aliases
alias ls='ls -AF --color=auto'
alias grep='grep --color=auto'
alias vim="vim -X"
alias view="vim -R"

######## Custom settings
export PAGER="/bin/less -s"
bindkey -v
export EDITOR="vim"

BLACK="%{"$'\033[01;30m'"%}"
GREEN="%{"$'\033[01;32m'"%}"
RED="%{"$'\033[01;31m'"%}"
YELLOW="%{"$'\033[01;33m'"%}"
BLUE="%{"$'\033[01;34m'"%}"
BOLD="%{"$'\033[01;39m'"%}"
NORM="%{"$'\033[00m'"%}"
# history settings
HISTFILE=~/.zshhistory
HISTSIZE=3000
SAVEHIST=3000

# VI settings
export EXINIT="set ai sm sw=2 sts=2 bs=2 showmode ruler guicursor=a:blinkon0"
export DISPLAY="`echo $SSH_CONNECTION | awk '{print $1}'`:0.0"

export LSOPT="--color=auto"

LS_COLORS='ow=01;35:di=01;35'
export LS_COLORS

#export PS1="${BLUE}[%n@%m]${RED} %~${NORM} "
export RPROMPT="${%}[%?]%{%}"

