#!/bin/zsh
### .zprofile
###   - sourced for login shells
###


### }}}
### general settings {{{
###

# turn off bell for login shells too.
#xset b off

export PAGER="/bin/less -sR"

### }}}

# determine which profile to source based upon hostname
CURRENT_HOST=`hostname`
CURRENT_HOST=${CURRENT_HOST%%[0-9]*}
if [[ $CURRENT_HOST == "slaptopen" || $CURRENT_HOST == "dev" || $CURRENT_HOST == "asusen" ]]
then
  test -f ~/.zsh/profiles/home.zprofile && source ~/.zsh/profiles/home.zprofile
elif [[ $CURRENT_HOST == "gbguxs" ]]
then
  test -f ~/.zsh/profiles/work.zprofile && source ~/.zsh/profiles/work.zprofile
elif [[ $CURRENT_HOST == "mintvm" ]]
then
  test -f ~/.zsh/profiles/workvm.zprofile && source ~/.zsh/profiles/workvm.zprofile
elif [[ $CURRENT_HOST =~ "SCANL" ]]
then
  # Running under Cygwin - no customizations yet
  ;
else
  return `error "unknown host"`
fi
