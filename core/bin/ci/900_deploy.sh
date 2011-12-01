#!/bin/bash
banner "Deploying..."
source "$HOME/.rvm/scripts/rvm"
rvm use --default 1.9.2-p290 || exit 1

if [ "$GIT_BRANCH" == "release"]; then
  SERVER="staging"
else
  SERVER="testserver"
fi

cap -q $SERVER deploy || exit 1
exit
