#!/bin/bash

echo "deploying to $DEPLOY_SERVER"

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

cap -S "branch=$GIT_COMMIT" -q $DEPLOY_SERVER deploy || exit 1

echo "deployed to $DEPLOY_SERVER"
exit
