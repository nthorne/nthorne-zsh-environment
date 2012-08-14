### work.zshrc
###   - settings for when at work
###

# vim: set filetype=zsh :

source ~/.zsh/common.zsh


### }}}
### aliases {{{
###

alias sambaconnect="smbclient '\\\\stosamba01\\nthorne' -U nthorne"

alias gm="nice -n 10 gmake NO_OPTIMIZATION=YesPlease"
alias gj="nice -n 10 gmake NO_OPTIMIZATION=YesPlease -j 30 -l 20"
alias gjo="nice -n 10 gmake NO_OPTIMIZATION=YesPlease -s -k -j9 SIL4_TARGET=OBJECTS"
alias gjc="nice -n 10 gmake -s -k -j clean"
alias gjca="nice -n 10 gmake -s -k -j clean-all"
alias gt="nice -n 10 gmake NO_OPTIMIZATION=YesPlease test cov"
alias gjt="nice -n 10 gmake -s -k -j9 test cov"
alias gjs="nice -n 10 gmake -k -j 9 NO_OPTIMIZATION=YesPlease stub_targets"

alias cleantcc="(cd $CURRENT_PROJECT_ROOT/Implementation; ./makesys clean-all)"
alias mktcc="(cd $CURRENT_PROJECT_ROOT/Implementation;\
  ./makesys NO_OPTIMIZATION=YesPlease)"

alias mkfsp="(cd $CURRENT_PROJECT_ROOT/Distribution/SunOS_i86pc/bin;\
  rm fsp* ; cd ../../../Implementation ; gmake NO_OPTIMIZATION=YesPlease)"

alias mkstubs="(cd $CURRENT_PROJECT_ROOT/Implementation;\
  ./makesys NO_OPTIMIZATION=YesPlease stub_targets)"

alias cleartcc="pushd /opt/interflo/Users/nthorne/bin;\
  ../scripts/clearNVM 10350 ; prepareEventlog.sh 10350 ; popd"

alias vfl="view /opt/interflo/Users/nthorne/log/fsp_simA.10350.log"
alias lc="ls -l /opt/interflo/Users/nthorne/cores"
alias rc="rm -rf /opt/interflo/Users/nthorne/cores/*"
alias tlog="tail -f /opt/interflo/Users/nthorne/log/fsp_simA.10350.log"


alias todos="find . -name '*.?pp' ! -name '*Test*' ! -name '*tub.*'\
  -exec egrep -i 'todo|fixme|xxx' {} +"
alias todofiles="find . -name '*.?pp' ! -name '*Test*' ! -name '*tub.*'\
  -exec egrep -li 'todo|fixme|xxx' {} +"

alias message_grep="grep -e 'StpHandler[^N]\{1,\}NID_MESSAGE: [0-9]\{1,\}'"
alias position_grep="grep -e 'Safe \(front\|rear\) position.*$'"

alias ss="batch_nontest fgrep"

alias go="ssh interflo@gbglemmel 'cd Users/nthorne/current; ./go'"


### }}}
### functions {{{
###


# function read_current_project() {{{
#   read the configuration file that details current project,
#   if one such file exists
function read_current_project()
{
  if [[ ! -f ~/current_project.zsh ]]
  then
    export RPROMPT="$RPROMPT ${RED}[NO PROJECT]${NORM}"
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

    if [[ ! -d $CURRENT_PROJECT_ROOT ]]
    then
      return `error "$CURRENT_PROJECT_ROOT does not exist or is not a directory"`
    fi

    export RPROMPT="$RPROMPT ${GREEN}[$CURRENT_PROJECT]${NORM}"
  fi
}
# }}}

# function runtest() {{{
#   build and run a named units test
#
# arguments:
#   $1 - the name of the unit to test
function runtest()
{
  local readonly TEST=test/.out/${1%%.cpp}Test
  gmake NO_OPTIMIZATION=YesPlease $TEST
  $TEST
}
# }}}

# function viewtest() {{{
#   view a named units test log file
#
# arguments:
#   $1 - the name of the unit
function viewtest()
{
  local FILE

  for FILE in `find test/.out/ -name "$1*.log"`
  do
    echo "--- `basename $FILE .log` ---"
    cat $FILE
  done
}
# }}}

# function viewcov() {{{
#   view a named units coverage log
#
# arguments:
#   $1 - the name of the unit
function viewcov()
{
  local FILE

  for FILE in `find .cov/ -name "$1*.tcov"`
  do
    echo "--- `basename $FILE .tcov` ---"
    cat $FILE
  done
}
# }}}

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
  local readonly INTERPRETER=${2:-/bin/bash -}

  if [[ -z $1 ]]
  then
    return `error "no script named"`
  fi

  if [[ -z $2 ]]
  then
    cp /home/nthorne/Tools/Scripts/template_bash $1 && chmod u+wx $1
  else
    INTERPRETER=$(command -v $INTERPRETER)
    echo "#!$INTERPRETER" > $1 ; chmod u+x $1
  fi
}
# }}}

# function lintall() {{{
#   lint all files in PWD and below
function lintall()
{
  ssh linthost "source /etc/zprofile ; cd /host/"$PWD" ; make NO_OPTIMIZATION=y lint"
}
# }}}

# function lintit() {{{
#   lint a named file
#
# arguments:
#   $1 - the name of the file to lint
# returns:
#   1 if the named file does not exist
function lintit()
{
  if [[ -z $1 ]]
  then
    return `error: "$1: no such file"`
  fi

  local filename=$(basename $1)
  local dirname=$(dirname $1)

  gmake -k $dirname/.lint/$filename.err ; vim -o $dirname/.lint/$filename.log $1
}
# }}}

# function construct_subproject_quickcd_aliases() {{{
#   construct nifty path aliases based on the CURRENT_PROJECT_ROOT variable
function construct_subproject_quickcd_aliases()
{
  local source_folder
  local project_root

  for source_folder in $(find $CURRENT_PROJECT_ROOT -type d -name source)
  do
    project_root=${source_folder%%'/Implementation/source'}
    project_name=$(basename $project_root)
    alias $project_name="cd $project_root"
  done
}
# }}}


### }}}

read_current_project
construct_subproject_quickcd_aliases
