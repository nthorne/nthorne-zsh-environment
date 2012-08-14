### home.zshrc
###   - settings for when at home
###

# vim: set filetype=zsh :

source ~/.zsh/lib/common.zsh


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
  # INTERPRETER defaults to bash, if no argument is given
  local readonly INTERPRETER=${2:-/bin/bash -}

  if [[ -z $1 ]]
  then
    return `error "no script named"`
  fi

  echo "#!$INTERPRETER" > $1 ; chmod u+x $1
}
# }}}
