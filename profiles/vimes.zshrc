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
  echo "Building ccls settings file.."
  echo "clang" > .ccls
  echo "%c -std=c99" >> .ccls
  echo "%cpp -std=c++17" >> .ccls
  find . -name \*include -o -name testutils -o -name gtest_gmock | fgrep -v build | xargs -I{} echo "-I{}" >> .ccls
}

eval "$(direnv hook zsh)"

### }}}

