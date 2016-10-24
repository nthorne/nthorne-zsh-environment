### workvm.zshrc
###   - settings for work vm
###

# vim: set filetype=zsh :

source ~/.zsh/lib/common.zsh

# function precmd_adaptation() {{{
#   extend precmd
function _precmd_adaptation()
{
  if [[ -n "$CURRENT_PROJECT" ]]
  then
    if [[ ! "$RPROMPT" =~ project: ]]
    then
      export RPROMPT="${BLUE}[${GREEN}project:$CURRENT_PROJECT${BLUE}]${NORM}"

      construct_subproject_quickcd_aliases
    fi
  elif [[ ! "$RPROMPT" =~ PROJECT ]]
  then
    export RPROMPT="${BLUE}[${RED}NO PROJECT${BLUE}]${NORM}"
  fi
}


### }}}
### aliases {{{
###

alias mkstubs="buildtcc.sh stub_targets"

alias ehu="cd export/home/Users/$USER"

alias oi="cd opt/interflo"

# Remote servers cannot handle xterm-256color
alias ssh="TERM=xterm ssh"


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

# function construct_subproject_quickcd_aliases() {{{
#   construct nifty path aliases based on the CURRENT_PROJECT_ROOT variable
function construct_subproject_quickcd_aliases()
{
  local source_folder
  local project_root

  if [[ ! -z $CURRENT_PROJECT_ROOT ]]
  then
    for source_folder in $(find $CURRENT_PROJECT_ROOT -type d -name source)
    do
      project_root=$source_folder
      project_name=$(basename ${project_root%%Implementation/source})
      if [[ -n "$project_name" && "$project_name" != "source" ]]
      then
        alias $project_name="cd ${project_root%%Implementation/source}"
      fi
    done
  fi
}
# }}}

# function mkbranches() {{{
#   create a matching set of git branches in both Core and Adaptation in
#   $CURRENT_PROJECT_ROOT
#
# arguments:
#   $1 - the name of the new branches
function mkbranches()
{
  if [[ ! -z $CURRENT_PROJECT_ROOT && -d $CURRENT_PROJECT_ROOT && ! -z $1 ]]
  then
    pushd $CURRENT_PROJECT_ROOT > /dev/null
    echo "*** Creating Adaptation branch ***"
    git checkout -b $1
    cd Implementation/TCC_SW
    echo
    echo "*** Creating Core branch ***"
    git checkout -b $1
    popd > /dev/null
  fi
}
# }}}

# function cobranches() {{{
#   check out a matching pair of branches in both Core and Adaptation
#
# arguments:
#   $1 - the name of the branch
function cobranches()
{
  if [[ ! -z $CURRENT_PROJECT_ROOT && -d $CURRENT_PROJECT_ROOT && ! -z $1 ]]
  then
    pushd $CURRENT_PROJECT_ROOT > /dev/null
    echo "*** Switching Adaptation branch ***"
    git checkout $1
    cd Implementation/TCC_SW
    echo
    echo "*** Switching Core branch ***"
    git checkout $1
    popd > /dev/null
  fi
}
# }}}

# function rmbranches() {{{
#   delete a matching pair of branches in both Core and Adaptation
#
# arguments:
#   $1 - the name of the branch
function rmbranches()
{
  if [[ ! -z $CURRENT_PROJECT_ROOT && -d $CURRENT_PROJECT_ROOT && ! -z $1 ]]
  then
    pushd $CURRENT_PROJECT_ROOT > /dev/null
    echo "*** Deleting Adaptation branch ***"
    git branch -d $1
    cd Implementation/TCC_SW
    echo
    echo "*** Deleting Core branch ***"
    git branch -d $1
    popd > /dev/null
  fi
}

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

eval "$(direnv hook zsh)"

# NOTE: Place this one after the direnv hook to get proper evaluation order.
typeset -ag precmd_functions;
if [[ -z ${precmd_functions[(r)_precmd_adaptation]} ]]; then
  precmd_functions+=_precmd_adaptation;
fi

### }}}

