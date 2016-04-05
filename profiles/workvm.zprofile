### workvm.zshprofile
###   - settings for work vm
###

# vim: set filetype=zsh :

export http_proxy="http://webproxy.scan.bombardier.com:8080"
export https_proxy="http://webproxy.scan.bombardier.com:8080"

export PATH=/home/nthorne/bin:/opt/scala-2.11.8/bin:$PATH

# For shellcheck
export PATH=$PATH:/home/nthorne/.cabal/bin/

# For scala
export SCALA_HOME=/opt/scala-2.11.8
