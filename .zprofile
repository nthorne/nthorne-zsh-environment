#!/bin/zsh
### .zprofile
###   - sourced for login shells
###


### }}}
### general settings {{{
###

# turn off bell for login shells too.
#xset b off

export PAGER="/bin/less -s"

### }}}

# determine which profile to source based upon hostname
if [[ `hostname` =~ "slaptopen" ]]
then
  test -f ~/.zsh/profiles/home.zprofile && source ~/.zsh/profiles/home.zprofile
elif [[ `hostname` =~ "gbguxs[0-9]+" ]]
then
  test -f ~/.zsh/profiles/work.zprofile && source ~/.zsh/profiles/work.zprofile
else
  return `error "unknown host"`
fi
