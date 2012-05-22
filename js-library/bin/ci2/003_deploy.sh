#!/bin/bash
echo "deploying to $DEPLOY_SERVER"

cap -S "branch=$GIT_COMMIT" -q $DEPLOY_SERVER deploy || exit 1

echo "deployed to $DEPLOY_SERVER"
exit
