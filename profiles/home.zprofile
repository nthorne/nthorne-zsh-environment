### home.zshprofile
###   - settings for when at home
###

# vim: set filetype=zsh :

# For PI development
export PATH=$PATH:/opt/crosstool-ng/bin

# For Android development
export PATH=$PATH:/opt/android-sdk-linux/tools
export PATH=$PATH:/opt/android-sdk-linux/platform-tools

# For todo.txt
export PATH=$PATH:/home/nthorne/repos/todo.txt-cli

# For go
export PATH=$PATH:/home/nthorne/bin/go/bin
export GOPATH=/home/nthorne/src/go

# For dart
if [[ -d /home/nthorne/bin/dart ]]
then
  export PATH=$PATH:/home/nthorne/bin/dart/
  export PATH=$PATH:/home/nthorne/bin/dart/dart-sdk/bin
fi

# For appengine
if [[ -d /home/nthorne/bin/go_appengine ]]
then
  export PATH=$PATH:/home/nthorne/bin/go_appengine
fi

# For ADT
if [[ -d /home/nthorne/bin/adt-bundle-linux-x86-20140702/eclipse ]]
then
  export PATH=$PATH:/home/nthorne/bin/adt-bundle-linux-x86-20140702/eclipse
fi
