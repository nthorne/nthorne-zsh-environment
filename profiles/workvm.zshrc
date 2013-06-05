### workvm.zshrc
###   - settings for work vm
###

# vim: set filetype=zsh :

source ~/.zsh/lib/common.zsh

# function read_current_project() {{{
#   read the configuration file that details current project,
#   if one such file exists
function read_current_project()
{
  if [[ ! -f ~/current_project.zsh ]]
  then
    export RPROMPT="$RPROMPT ${BLUE}[${RED}NO PROJECT${BLUE}]${NORM}"
  else
    source ~/current_project.zsh

    if [[ -z $CURRENT_PROJECT ]]
    then
      return `error '$CURRENT_PROJECT not set in ~/current_project.zsh'`
    fi

    if [[ -z $CURRENT_PROJECT_ROOT ]]
    then
      return `error '$CURRENT_PROJECT_ROOT not set in ~/current_project.zsh'`
    fi

    if [[ -z $CURRENT_PROJECT_INSTALL_PATH ]]
    then
      return `error '$CURRENT_PROJECT_INSTALL_PATH not set in ~/current_project.zsh'`
    fi

    if [[ -z $CURRENT_PROJECT_REMOTE_USER ]]
    then
      return `error '$CURRENT_PROJECT_REMOTE_USER not set in ~/current_project.zsh'`
    fi

    if [[ -z $CURRENT_PROJECT_REMOTE_ROOT ]]
    then
      return `error '$CURRENT_PROJECT_REMOTE_ROOT not set in ~/current_project.zsh'`
    fi

    if [[ -z $CURRENT_PROJECT_REMOTE_PATH ]]
    then
      return `error '$CURRENT_PROJECT_REMOTE_PATH not set in ~/current_project.zsh'`
    fi

    if [[ ! -d $CURRENT_PROJECT_ROOT ]]
    then
      return `error "$CURRENT_PROJECT_ROOT does not exist or is not a directory"`
    fi

    export RPROMPT="$RPROMPT ${BLUE}[${GREEN}project:$CURRENT_PROJECT${BLUE}]${NORM}"
  fi
}
# }}}

read_current_project

### }}}
### aliases {{{
###

alias cleantcc="synctcc; ssh $CURRENT_PROJECT_REMOTE_USER \"source /etc/profile; \
  cd $CURRENT_PROJECT_REMOTE_ROOT/Implementation; ./makesys clean-all\""
alias mktcc="synctcc; ssh $CURRENT_PROJECT_REMOTE_USER \"source /etc/profile; \
  cd $CURRENT_PROJECT_REMOTE_ROOT/Implementation; \
  ./makesys NO_OPTIMIZATION=YesPlease\""

alias mkfsp="synctcc; ssh $CURRENT_PROJECT_REMOTE_USER \"source /etc/profile; \
  cd $CURRENT_PROJECT_REMOTE_ROOT/Distribution/SunOS_i86pc/bin;\
  rm fsp* ; cd ../../../Implementation ; gmake NO_OPTIMIZATION=YesPlease\""

alias mkstubs="synctcc; ssh $CURRENT_PROJECT_REMOTE_USER \"source /etc/profile; \
  cd $CURRENT_PROJECT_REMOTE_ROOT/Implementation;\
  ./makesys NO_OPTIMIZATION=YesPlease stub_targets\""

alias pushtcc="ssh $CURRENT_PROJECT_REMOTE_USER \"source /etc/profile; pushtcc\""

alias ss="batch_nontest fgrep"



### }}}
### functions {{{
###

# function batch_nontest() {{{
#   run a given command on all non-unit test cpp/hpp files in PWD and below
#
# arguments:
#   $@ - the command to execute
function batch_nontest()
{
  find . -type f -name '*.?pp' ! -name '*[Tt]est*' ! -name '*[Ss]tub*' -exec $@ {} +
}
# }}}

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
      project_root=${source_folder%%'/Implementation/source'}
      project_name=$(basename $project_root)
      alias $project_name="cd $project_root"
    done
  fi
}
# }}}


### }}}

construct_subproject_quickcd_aliases
