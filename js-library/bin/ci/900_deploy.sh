#!/bin/bash

if [[ ! -z $DEPLOY_SERVER ]]; then
  echo "deploying to $DEPLOY_SERVER"

  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"

  cap -S "branch=$GIT_COMMIT" -q $DEPLOY_SERVER deploy || exit 1

  echo "deployed to $DEPLOY_SERVER"
else
  echo "No DEPLOY_SERVER found, not deploying."
fi

exit
