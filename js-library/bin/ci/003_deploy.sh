#!/bin/bash
echo "Deploying js-library to testserver"
source "$HOME/.rvm/scripts/rvm"
rvm use --default 1.9.2-p290
if [ "$GIT_BRANCH" == "release" ] ; then
  SERVER="staging"
else
  SERVER="testserver"
fi

echo "deploying to $SERVER"
cap -q $SERVER deploy || exit 1
echo "deployed to $SERVER"
exit
