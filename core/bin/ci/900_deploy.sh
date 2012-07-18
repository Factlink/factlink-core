#!/bin/bash
echo "Deploying..."

echo "deploying to $DEPLOY_SERVER"
bundle exec cap -S "branch=$GIT_COMMIT" $DEPLOY_SERVER deploy || exit 1
echo "deployed to $DEPLOY_SERVER"
exit
