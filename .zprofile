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
export TERM="xterm-256color"

### }}}

# determine which profile to source based upon hostname
CURRENT_HOST=`hostname`
CURRENT_HOST=${CURRENT_HOST%%[0-9]*}
if [[ $CURRENT_HOST == "slaptopen" || $CURRENT_HOST == "dev" || $CURRENT_HOST == "asusen" ]]
then
  test -f ~/.zsh/profiles/home.zprofile && source ~/.zsh/profiles/home.zprofile
  if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
elif [[ $CURRENT_HOST == "gbguxs" ]]
then
  test -f ~/.zsh/profiles/work.zprofile && source ~/.zsh/profiles/work.zprofile
elif [[ $CURRENT_HOST == "mintvm" || $CURRENT_HOST == "nixos" ]]
then
  test -f ~/.zsh/profiles/workvm.zprofile && source ~/.zsh/profiles/workvm.zprofile
elif [[ $CURRENT_HOST =~ "BTIS" ]]
then
  test -f ~/.zsh/profiles/work_cyg.zprofile && source ~/.zsh/profiles/work_cyg.zprofile
else
  return `error "unknown host"`
fi

