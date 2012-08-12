# vim: set filetype=zsh :

source ~/.zsh/common.zsh


function mkscript()
{
  local readonly INTERPRETER=${2:-/bin/bash -}

  if [[ -z $1 ]]
  then
    return `error "no script named"`
  fi

  echo "#!$INTERPRETER" > $1 ; chmod u+x $1
}

