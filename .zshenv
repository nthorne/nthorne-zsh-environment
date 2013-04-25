CURRENT_HOST=`hostname`
CURRENT_HOST=${CURRENT_HOST%%[0-9]*}
if [[ $CURRENT_HOST == "gbguxs" ]]
then
  export PATH=/opt/git-1.7.11/bin:/export/home/Users/nthorne/bin:$PATH
  export LD_LIBRARY_PATH=/usr/sfw/lib:/usr/local/lib:$LD_LIBRARY_PATH
fi
