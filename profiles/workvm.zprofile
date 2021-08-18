### workvm.zshprofile
###   - settings for work vm
###

# vim: set filetype=zsh :

export PATH=/home/nthorne/bin:/opt/scala-2.11.8/bin:$PATH

# For shellcheck
export PATH=$PATH:/home/nthorne/.cabal/bin/

# For scala
export SCALA_HOME=/opt/scala-2.11.8

# Needed for deoplete
export PYTHONPATH=$PYTHONPATH:$HOME/.local/lib/python3.6/site-packages/

# Needed for home manager
test -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" && source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
