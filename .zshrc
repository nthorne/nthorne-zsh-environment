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

export PAGER="/bin/less -sR"
export EDITOR="vim"

# history settings
HISTFILE=~/.zshhistory
HISTSIZE=3000
SAVEHIST=3000

# VI settings
export EXINIT="set ai sm sw=2 sts=2 bs=2 showmode ruler guicursor=a:blinkon0"

# use vi keybindings
bindkey -v

zle -N globalias
zle -N rationalise-dot

# keybindings for alias expansion
bindkey " " globalias               # expand on space
bindkey "^ " magic-space            # <C-space> to bypass expansion
bindkey -M isearch " " magic-space  # use normal space during searches

bindkey '^r' history-incremental-search-backward

# keybinding for dot expansion
bindkey . rationalise-dot

# set the DISPLAY variable automatically, using the IP address from SSH_CONNECTION
export DISPLAY="`echo $SSH_CONNECTION | awk '{print $1}'`:0.0"

export LSOPT="--color=auto"
export LS_COLORS='ow=01;35:di=01;35'

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

#global aliases
alias -g C='| wc -l'
alias -g F='| fgrep'
alias -g FI='| fgrep -i'
alias -g FV='| fgrep -v'
alias -g G='| egrep'
alias -g H='| head'
alias -g L='| less'
alias -g S='| sort'
alias -g T='| tail'
alias -g EN="2>/dev/null"
alias -g ON="1>/dev/null"

# suffix aliases
alias -s md=vim
alias -s cpp=vim
alias -s hpp=vim

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
  test -d "$1" || return
  test -f bin/activate

  # source the virtualenv activation script
  . bin/activate

  cd $1

  # exporting this variable causes its value to be appended to RPROMPT
  export ACTIVE_VIRTUALENV=$1
}
# }}}

# function unuseenv() {{{
#   deactivate the selected virtualenv
function unuseenv()
{
  deactivate
  unset ACTIVE_VIRTUALENV
  export RPROMPT="${%}[%?]%{%}"
}

function globalias () {
  # Expand upper-case global aliases
  if [[ $LBUFFER =~ ' [A-Z0-9]+$' ]]
  then
    zle _expand_alias
    zle expand-word
  fi
  zle self-insert
}

function rationalise-dot () {
  if [[ $LBUFFER =~ '[ \/]\.\.$' ]]
  then
    LBUFFER+=/..
  else
    LBUFFER+=.
  fi
}
# }}}


### }}}

# determine which profile to source based upon hostname
# NOTE: The dirty, ugly hack of removing trailing numericals, is in order to
#  cope with the fact that at work, there is no zsh/regex module :(
CURRENT_HOST=`hostname`
CURRENT_HOST=${CURRENT_HOST%%[0-9]*}
if [[ $CURRENT_HOST == "slaptopen" || $CURRENT_HOST == "dev" ]]
then
  test -f ~/.zsh/profiles/home.zshrc && source ~/.zsh/profiles/home.zshrc
elif [[ $CURRENT_HOST == "gbguxs" ]]
then
  test -f ~/.zsh/profiles/work.zshrc && source ~/.zsh/profiles/work.zshrc
elif [[ $CURRENT_HOST == "mintvm" ]]
then
  test -f ~/.zsh/profiles/workvm.zshrc && source ~/.zsh/profiles/workvm.zshrc
elif [[ $CURRENT_HOST =~ "SCANL" ]]
then
  # Running under Cygwin - no customizations yet
  ;
else
  return `error "unknown host"`
fi
