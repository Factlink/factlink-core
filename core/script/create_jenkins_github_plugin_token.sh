#!/bin/bash

# One FL dev can use this to generate a token for https://wiki.jenkins-ci.org/display/JENKINS/Github+Plugin
# This token can be used (e.g.) by the Jenkins set commit status post-build action.


if [ $# -ne 1 ]; then
  echo "Usage: $0 <github-username>"
  exit 1
fi

curl -u "$1" -d '{
  "scopes":["repo:status"],
  "note":"Jenkins-Commit-Statusses",
  "note_url":"https://ci-factlink.inverselink.com/",
  "client_id":"2ecd296614f9a61cbcec",
  "client_secret":"fe0341da1858d6cc688bd313117db1e0762e84f6"
  }' \
  https://api.github.com/authorizations
