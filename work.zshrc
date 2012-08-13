# vim: set filetype=zsh :

source ~/.zsh/common.zsh


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

function runtest()
{
  local readonly TEST=test/.out/${1%%.cpp}Test
  gmake NO_OPTIMIZATION=YesPlease $TEST
  $TEST
}

function viewtest()
{
  local FILE

  for FILE in `find test/.out/ -name "$1*.log"`
  do
    echo "--- `basename $FILE .log` ---"
    cat $FILE
  done
}

function viewcov()
{
  local FILE

  for FILE in `find .cov/ -name "$1*.tcov"`
  do
    echo "--- `basename $FILE .tcov` ---"
    cat $FILE
  done
}

function starttcc()
{
  local readonly LEVEL=${1-info+}

  pushd /opt/interflo/Users/nthorne/bin > /dev/null
  rm -rf ../cores/core.* &> /dev/null

  ./tcc_sim restart 10350 $LEVEL && tail -f ../log/fsp_simA.10350.log
}

function gas()
{
  cd ~/TCC_LKAB_SW/Implementation/$1/Implementation/source
}

function gcs()
{
  cd ~/TCC_SW/$1/Implementation/source
}

function batch_nontest()
{
  find . -type f -name '*.?pp' ! -name '*[Tt]est*' ! -name '*[Ss]tub*' -exec $@ {} +
}

function logtoggle()
{
  local SESSION=10350
  local LEVEL=default

  if [[ -n $1 && -z $2 ]]
  then
    LEVEL=$1
  elif [[ -n $1 && -n $2 ]]
  then
    SESSION=$1
    LEVEL=$2
  fi

  pushd /home/nthorne/bin &>/dev/null
  java udpsend 127.0.0.1 $SESSION $LEVEL
  popd &> /dev/null
}

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

function qdbx()
{
  if [[ -z $1 ]]
  then
    echo "usage: $1 CORE"
    return 0
  fi

  dbx "../bin/$(echo $1 | cut -d. -f2)" $1
}

function lintall()
{
  ssh linthost "source /etc/zprofile ; cd /host/"$PWD" ; make NO_OPTIMIZATION=y lint"
}

function lintit()
{
  if [[ -z $1 ]]
  then
    echo "$1: no such file"
    return 1
  fi

  local filename=$(basename $1)
  local dirname=$(dirname $1)

  gmake -k $dirname/.lint/$filename.err ; vim -o $dirname/.lint/$filename.log $1
}

function can_ci()
{
  if [[ -z $1 || ! -f $1 ]]
  then
    echo "$1: no such file"
    return 1
  fi

  local todos="$(fgrep -n -i 'TODO' $1)"

  if [[ -n $todos ]]
  then
    echo "WARN: TODO:s present:"
    echo $todos
    echo
  fi

  local debuglogs="$(fgrep -n '"666"' $1)"

  if [[ -n $debug_logs ]]
  then
    echo "FAIL: Debug log statements present:"
    echo $debuglogs
    echo

    return 1
  fi

  lintit "$1"
}

alias sambaconnect="smbclient '\\\\stosamba01\\nthorne' -U nthorne"

alias gm="nice -n 10 gmake NO_OPTIMIZATION=YesPlease"
alias gj="nice -n 10 gmake NO_OPTIMIZATION=YesPlease -j 30 -l 20"
alias gjo="nice -n 10 gmake NO_OPTIMIZATION=YesPlease -s -k -j9 SIL4_TARGET=OBJECTS"
alias gjc="nice -n 10 gmake -s -k -j clean"
alias gjca="nice -n 10 gmake -s -k -j clean-all"
alias gt="nice -n 10 gmake NO_OPTIMIZATION=YesPlease test cov"
alias gjt="nice -n 10 gmake -s -k -j9 test cov"
alias gjs="nice -n 10 gmake -k -j 9 NO_OPTIMIZATION=YesPlease stub_targets"

alias cleantcc='(cd ~/TCC_LKAB_SW/Implementation; ./makesys clean-all)'
alias mktcc='(cd ~/TCC_LKAB_SW/Implementation ; ./makesys NO_OPTIMIZATION=YesPlease)'

alias mkfsp='(cd ~/TCC_LKAB_SW/Distribution/SunOS_i86pc/bin ; rm fsp* ; cd ../../../Implementation ; gmake NO_OPTIMIZATION=YesPlease)'

alias mkstubs='(cd ~/TCC_LKAB_SW/Implementation ; ./makesys NO_OPTIMIZATION=YesPlease stub_targets)'

alias cleartcc="pushd /opt/interflo/Users/nthorne/bin ; ../scripts/clearNVM 10350 ; prepareEventlog.sh 10350 ; popd"

alias vfl="view /opt/interflo/Users/nthorne/log/fsp_simA.10350.log"
alias lc="ls -l /opt/interflo/Users/nthorne/cores"
alias rc="rm -rf /opt/interflo/Users/nthorne/cores/*"
alias tlog="tail -f /opt/interflo/Users/nthorne/log/fsp_simA.10350.log"

alias RBA="cd ~/RBA_LKAB/Implementation/source"
alias CBR3="cd ~/CBR3/Implementation/source"

alias todos="find . -name '*.?pp' ! -name '*Test*' ! -name '*tub.*' -exec egrep -i 'todo|fixme|xxx' {} +"
alias todofiles="find . -name '*.?pp' ! -name '*Test*' ! -name '*tub.*' -exec egrep -li 'todo|fixme|xxx' {} +"

alias message_grep="grep -e 'StpHandler[^N]\{1,\}NID_MESSAGE: [0-9]\{1,\}'"
alias position_grep="grep -e 'Safe \(front\|rear\) position.*$'"

alias ss="batch_nontest fgrep"

alias go="ssh interflo@gbglemmel 'cd Users/nthorne/current; ./go'"

alias dsw="(cd $HOME; rm TCC_LKAB_SW; ln -s TCC_LKAB_SW-nthorne/TCC_LKAB_SW .)"
alias msw="(cd $HOME; rm TCC_LKAB_SW; ln -s TCC_LKAB_SW-nthorne_maintenance/TCC_LKAB_SW .)"

