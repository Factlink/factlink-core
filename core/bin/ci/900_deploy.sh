#!/bin/bash
if [[ -z "$DEPLOY_SERVER" ]]; then
  echo "Deploying..."

  echo "deploying to $DEPLOY_SERVER"
  bundle exec cap -S "branch=$GIT_COMMIT" $DEPLOY_SERVER deploy || exit 1
  echo "deployed to $DEPLOY_SERVER"
else
  echo "No DEPLOY_SERVER found, not deploying."
fi

exit
