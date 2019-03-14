#!/usr/bin/env bash

# vim: filetype=sh

# Set IFS explicitly to space-tab-newline to avoid tampering
IFS=' 	
'


NAME=
# Make sure that we're not on NixOS; if so, avoid tampering with PATH
if [[ -f /etc/os-release ]]
then
  . /etc/os-release
fi

if [[ "NixOS" != "$NAME" ]]
then
  # If found, use getconf to constructing a reasonable PATH, otherwise
  # we set it manually.
  if [[ -x /usr/bin/getconf ]]
  then
    PATH=$(/usr/bin/getconf PATH)
  else
    PATH=/bin:/usr/bin:/usr/local/bin
  fi
fi

function error()
{
  echo "Error: $@" >&2
  exit 1
}

ln -s ${PWD} ${HOME}

pushd ${HOME}
ln -s .zsh/.zshrc .
ln -s .zsh/.zprofile .
ln -s .zsh/.zshenv .
git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
popd
