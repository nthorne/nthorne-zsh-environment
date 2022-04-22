### .zshrc
###   - sourced for interactive shells
###

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
### modules {{{
###

# source the common functions
source ~/.zsh/lib/common.zsh

### }}}
### completions {{{
###

# Load and configure vcs_info
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git*' unstagedstr "${RED}+${NORM}"
zstyle ':vcs_info:git*' stagedstr "${GREEN}+${NORM}"
zstyle ':vcs_info:git*' formats " branch:%b%u%c"
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked

# partial completion suggestions
zstyle ':completion:*' list-suffixes zstyle ':completion:*' expand prefix suffix

# case insensitive path-completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'


# initialize the completion system
autoload -Uz compinit && compinit

### }}}
### general settings {{{
###

export PAGER="/bin/less -sR"
export EDITOR="nvim"

# Tell Java that XMonad is nonreparenting in order to avoid all-grey windows
export _JAVA_AWT_WM_NONREPARENTING=1

# VI settings
export EXINIT="set ai sm sw=2 sts=2 bs=2 showmode ruler guicursor=a:blinkon0"

export FZF_DEFAULT_OPTS="
--layout=reverse
--info=inline
--height=80%
--multi
--preview '([[ -f {} ]] && (cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'
--color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008'
--bind '?:toggle-preview'
--preview-window=hidden
"

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

# Disable oh-my-zsh update check query
export DISABLE_UPDATE_PROMPT="true"

# Disable SSH_ASKPASS
export SSH_ASKPASS=""

### }}}
### function definitions {{{
###

# function +vi-git-untracked()
#   show the ? marker if there is untracked files.
function +vi-git-untracked(){
  if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
    git status --porcelain | grep '??' &> /dev/null ; then
    hook_com[staged]+="${RED}?${NORM}"
  fi
}

# function precmd() {{{
#   executed before each prompt
function precmd()
{
  vcs_info
  export PS1="${BLUE}[%n@%m${GREEN}\$vcs_info_msg_0_${BLUE}]${RED} %~${NORM} "

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
### Plugins {{{
###

# NOTE: Keep the plugins a bit from the end, since some of them re-alias,
# change keybindings etc.

# load zgen
readonly zgen_base_path="${HOME}/.zgen"
if [[ -d "${zgen_base_path}/" ]]
then
  source "${zgen_base_path}/zgen.zsh"

  # if the init scipt doesn't exist
  if ! zgen saved; then

    # specify plugins here
    zgen load mollifier/cd-gitroot
    zgen load zsh-users/zsh-autosuggestions
    zgen load willghatch/zsh-cdr
    zgen load zsh-users/zaw
    zgen load Tarrasch/zsh-bd
    zgen load unixorn/git-extra-commands
    zgen load wfxr/forgit
    zgen load djui/alias-tips
    zgen load zsh-users/zsh-completions
    zgen clone sachaos/todoist
    # generate the init script from plugins above
    zgen save
  fi
fi

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=23"

# history settings; reset by some plugin somewhere, so..
HISTFILE=~/.zshhistory
HISTSIZE=50000
SAVEHIST=40000
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST


### }}}
### aliases {{{
###

alias ls='ls -AF --color=auto'
alias grep='grep --color=auto'
alias vim="nvim"
alias view="nvim -R"
alias auu="apt update && apt upgrade"
alias _="sudo"
alias less="less -R"
alias md="mkdir"
alias fd="fd -H"
alias today="todoist l -f today -f overdue"

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

# .. order matters here.
alias -g ......='cd ../../../../../..'
alias -g .....='cd ../../../../..'
alias -g .....='cd ../../../..'
alias -g ....='cd ../../..'
alias -g ...='cd ../..'

# suffix aliases
alias -s md=vim
alias -s cpp=vim
alias -s hpp=vim

### }}}
### Key bindings {{{
###

# use vi keybindings
bindkey -v

# we need to re-set this one because of bindkey -v,
# and bindkey -v cannot take place before plugins
# section, or my vim keybindings will be messed up.
bindkey '^X;' zaw

bindkey '^Xk' run-help

bindkey "^[[1;5C" forward-word

### }}}
### More plugins {{{
###

### }}}
### Options {{{
###
setopt nosharehistory
setopt AUTO_CD
setopt MAGIC_EQUAL_SUBST
setopt GLOB_COMPLETE
unsetopt CASE_GLOB
unsetopt CASE_MATCH
setopt GLOB_ASSIGN
setopt GLOB_STAR_SHORT

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

### }}}
### Profile selection {{{
###

# determine which profile to source based upon hostname
# NOTE: The dirty, ugly hack of removing trailing numericals, is in order to
#  cope with the fact that at work, there is no zsh/regex module :(
CURRENT_HOST=`hostname`
CURRENT_HOST=${CURRENT_HOST%%[0-9]*}
if [[ $CURRENT_HOST == "slaptopen" || $CURRENT_HOST == "dev" || $CURRENT_HOST == "asusen" || $CURRENT_HOST == "nixlaptop" ]]
then
  test -f ~/.zsh/profiles/home.zshrc && source ~/.zsh/profiles/home.zshrc
elif [[ $CURRENT_HOST == "mintvm" || $CURRENT_HOST == "nixos" ]]
then
  test -f ~/.zsh/profiles/workvm.zshrc && source ~/.zsh/profiles/workvm.zshrc
elif [[ $CURRENT_HOST =~ "BTIS" ]]
then
  # Running under Cygwin - no customizations yet
  ;
else
  # Attempt the hostname based strategy or bail out..
  source ~/.zsh/profiles/${CURRENT_HOST}.zshrc || return `error "unknown host"`
fi
### }}}


### UNDER EVALUATION {{{
###

function _fasd_z_to_subfolder() {
  test -z "${1}" && echo "Missing subfolder argument." && return

  readonly subfolder=$(fasd -dl1 "${PWD}" "${1}")
  test -z  "${subfolder}" && echo "${1}: no such subfolder in fasd." && return
  test -d "${subfolder}" || return

  cd "${subfolder}"
}

function hashcwd() {
  hash -d "${1}="${PWD}""
}

## >>> This snippet is roughly from oh-my-zsh/fasd, in an attempt
##     to drop the framework entirely.
export ZSH_CACHE_DIR="${HOME}/.cache/zsh"
test -d "${ZSH_CACHE_DIR}" || mkdir -p "${ZSH_CACHE_DIR}"

# check if fasd is installed
if (( ${+commands[fasd]} )); then
  fasd_cache="${ZSH_CACHE_DIR}/fasd-init-cache"
  if [[ "$commands[fasd]" -nt "$fasd_cache" || ! -s "$fasd_cache" ]]; then
    fasd --init posix-alias zsh-hook zsh-ccomp zsh-ccomp-install \
      zsh-wcomp zsh-wcomp-install >| "$fasd_cache"
  fi
  source "$fasd_cache"
  unset fasd_cache

  alias v='f -e "$EDITOR"'
  alias o='a -e xdg-open'
  alias j='zz'
  alias zs=_fasd_z_to_subfolder
fi

## <<<

test -f "${zgen_base_path}/sachaos/todoist-master/todoist_functions_fzf.sh" && \
  . "${zgen_base_path}/sachaos/todoist-master/todoist_functions_fzf.sh"

# Don't think that I need this one any more..
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
# export SDKMAN_DIR="/home/nthorne/.sdkman"
# [[ -s "/home/nthorne/.sdkman/bin/sdkman-init.sh" ]] && source "/home/nthorne/.sdkman/bin/sdkman-init.sh"

### }}}
