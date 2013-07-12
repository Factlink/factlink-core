#!/bin/bash

# One FL dev can use this to generate a token for https://wiki.jenkins-ci.org/display/JENKINS/Github+Plugin
# This token can be used (e.g.) by the Jenkins set commit status post-build action.


if [ $# -ne 4 ]; then
  echo "Usage: $0 <sha> <status> <tartget_url> <description>"
  exit 1
fi

echo "https://api.github.com/repos/Factlink/core/statuses/$1"

curl -v -H 'Authorization: token b5e2ff58da90bd178ee24c7e51260653db7386d2' \
  "https://api.github.com/repos/Factlink/core/statuses/$1" \
  -d "{\"state\":\"$2\",\"target_url\":\"$3\",\"description\":\"$4\"}"

