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
#export TERM="screen-256color"

export PATH="$PATH:$HOME/.local/bin"

### }}}

# determine which profile to source based upon hostname
CURRENT_HOST=`hostname`
CURRENT_HOST=${CURRENT_HOST%%[0-9]*}
if [[ $CURRENT_HOST == "slaptopen" || $CURRENT_HOST == "dev" || $CURRENT_HOST == "asusen" || $CURRENT_HOST = "nixlaptop" ]]
then
  test -f ~/.zsh/profiles/home.zprofile && source ~/.zsh/profiles/home.zprofile
  if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
elif [[ $CURRENT_HOST == "mintvm" || $CURRENT_HOST == "nixos" ]]
then
  test -f ~/.zsh/profiles/workvm.zprofile && source ~/.zsh/profiles/workvm.zprofile
else
  return `error "unknown host"`
fi

