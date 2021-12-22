# vim: set filetype=zsh :

export PATH=/home/nthorne/bin:$PATH

# For shellcheck
export PATH=$PATH:/home/nthorne/.cabal/bin/

# Needed for deoplete
export PYTHONPATH=$PYTHONPATH:$HOME/.local/lib/python3.6/site-packages/

# Needed for home manager
test -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" && source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
