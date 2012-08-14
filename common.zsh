### common.zsh
###   - common scripting functions
###


# function error() {{{
#   echo message to STDERR
#
# arguments:
#   $@ - text to be written to stderr
# returns:
#   1
function error()
{
  echo "error: $@" 1>&2
  return 1
}
# }}}
