### workvm.zshrc
###   - settings for work vm
###

# vim: set filetype=zsh :

source ~/.zsh/lib/common.zsh

# function precmd_adaptation() {{{
#   extend precmd
function _precmd_adaptation()
{
  if [[ -n "$PROJECT_SETTINGS" && -f "$PROJECT_SETTINGS" && -z "$CURRENT_PROJECT" ]]
  then
    source "$PROJECT_SETTINGS"
  fi

  if [[ -n "$CURRENT_PROJECT" ]]
  then
    if [[ ! "$RPROMPT" =~ project: ]]
    then
      export RPROMPT="${BLUE}[${GREEN}project:$CURRENT_PROJECT${BLUE}]${NORM}"
    fi
  elif [[ ! "$RPROMPT" =~ PROJECT ]]
  then
    export RPROMPT="${BLUE}[${RED}NO PROJECT${BLUE}]${NORM}"
  fi
}


### }}}
### aliases {{{
###

alias sem="${HOME}/bin/aospsync.sh -p ${HOME}/work/sem -r as -t gtt_hydra-eng"
alias ihu="${HOME}/bin/aospsync.sh -p ${HOME}/work/ihu -r as -t ihu_kraken-eng"
# Remote servers cannot handle xterm-256color
alias ssh="TERM=xterm ssh"
alias mux=tmuxinator


### }}}
### functions {{{
###


# function mkscript() {{{
#   helper function for creating script file
#
# arguments:
#   $1 - name of script file to create
#   $2 - script interpreter (defaults to bash)
# returns:
#   1 upon missing script name
function mkscript()
{
  local INTERPRETER=${2:-bash -}
  local readonly BASH_TEMPLATE=/home/nthorne/Tools/Scripts/template_bash

  if [[ -z $1 ]]
  then
    return `error "no script named"`
  fi

  # if no interpreter is named, and a Bash template file exists, use it.
  # otherwise, expand INTERPRETER to the full path of the interpreter.
  if [[ -z $2 ]]
  then
    if [[ -f $BASH_TEMPLATE ]]
    then
      cp $BASH_TEMPLATE $1 && chmod u+wx $1
      return
    fi
  else
    INTERPRETER=$(command -v $INTERPRETER)
  fi

  echo "#!$INTERPRETER" > $1 ; chmod u+x $1
}
# }}}


# function cob() {{{
#   recursively check out a branch in each submodule, and merge the
#   local branch with its corresponding origin branch.
#
# arguments:
#   $1 - the name of the branch. Defaults to master.
function cob()
{
  local readonly branch=${1:-master}
  git submodule foreach "git checkout $branch; git merge --ff-only origin/$branch"
}
# }}}

function tx () {
  if [[ -n "$1" && -e "$1" ]]; then
    mv "$1" /media/sf_Documents/transfer
  else
    echo "$1: no such file or directory."
  fi
}

function csdb()
{
  echo "Building cscope database.."
  find . -type f -name \*.c -o -name \*.h | grep -Ev '(stub|test)' > cscope.files
  cscope -bcq
}

function ccls-init()
{
  echo "Building ccls settings file.."
  echo "clang" > .ccls
  echo "%c -std=c99" >> .ccls
  echo "%cpp -std=c++17" >> .ccls
  find . -name \*include -o -name testutils -o -name gtest_gmock | fgrep -v build | xargs -I{} echo "-I{}" >> .ccls
}

function bb()
{
  test -n "${CURRENT_WORK_PROJECT_ROOT}" || return `error "CURRENT_WORK_PROJECT_ROOT not set"`
  test -n "${CURRENT_WORK_PROJECT_BUILD_TARGET}" || return `error "CURRENT_WORK_PROJECT_BUILD_TARGET not set"`

  ${HOME}/bin/aospsync.sh -p ${CURRENT_WORK_PROJECT_ROOT} -r as -t ${CURRENT_WORK_PROJECT_BUILD_TARGET} $@
}

function mkp()
{
  local readonly workdir="${HOME}/work/"
  test -n "$1" || error "Base project not specified."
  test -d "${workdir}/$1" || error "Base project does not exist."

  test -n "$2" || error "New project name not specified."
  test -d "${workdir}/$2" && error "New project already exists."

  sudo btrfs su sn "${workdir}/$1" "${workdir}/$1-$2" || error "Base project cloning failed."
  cd "${workdir}/$1-$2" || error "Failed to enter project directory"
}

eval "$(direnv hook zsh)"

# NOTE: Place this one after the direnv hook to get proper evaluation order.
typeset -ag precmd_functions;
if [[ -z ${precmd_functions[(r)_precmd_adaptation]} ]]; then
  precmd_functions+=_precmd_adaptation;
fi

### }}}

