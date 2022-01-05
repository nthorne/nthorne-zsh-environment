# vim: set filetype=zsh :

source ~/.zsh/lib/common.zsh


### }}}
### aliases {{{
###

# Remote servers cannot handle xterm-256color
alias ssh="TERM=xterm ssh"


### }}}
### functions {{{
###

# TODO: Drop or adapt.
function csdb()
{
  echo "Building cscope database.."
  find . -type f -name \*.c -o -name \*.h | grep -Ev '(stub|test)' > cscope.files
  cscope -bcq
}

# TODO: Drop or adapt.
function ccls-init()
{
  local CCLS_CONFIG=${HOME}/src/unicorn/.ccls

  echo "Using ${CCLS_CONFIG}.."
  cat <<-CCLS_CONFIG_HEADER > ${CCLS_CONFIG}
clang
%h -x c++-header
-Wall
-Wextra
%cpp -std=c++17
%c -std=c11
-I.
CCLS_CONFIG_HEADER

  find /home/nthorne/.conan/data -regextype egrep -iregex '.*/source/.*/include' ! -iregex '.*/test/.*' ! -iregex '.*/example/.*' | xargs -I{} echo "-I{}" >> ${CCLS_CONFIG}
  find /home/nthorne/src/unicorn -iname src | xargs -I{} echo "-I{}" >> ${CCLS_CONFIG}
}

eval "$(direnv hook zsh)"

### }}}

