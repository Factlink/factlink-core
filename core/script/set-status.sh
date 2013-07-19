#!/bin/bash

if [ $# -ne 4 ]; then
  echo 'Set the github build status for a commit (this includes the commit'\''s pull request)'.
  echo "Usage: $0 <sha> <status> <tartget_url> <description>"
  exit 1
fi

curl -# --silent -S -H 'Authorization: token b5e2ff58da90bd178ee24c7e51260653db7386d2' \
  "https://api.github.com/repos/Factlink/core/statuses/$1" \
  -d "{\"state\":\"$2\",\"target_url\":\"$3\",\"description\":\"$4\"}"

