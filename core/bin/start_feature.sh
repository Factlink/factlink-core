#!/bin/bash

git status | grep 'Changes not staged for commit'>/dev/null
if [ $? -eq 0 ]; then
  echo 'Please stash any changes before starting a new feature'
  exit 1
fi

if ["$1" == ""]; then
  echo "please specify the name of the feature (without spaces)"
  exit 1
fi

set -e

echo "starting feature $1"
git flow feature start $1
git flow feature publish $1
echo 'placeholder todo' > "$1.todo"
git add "$1.todo"
git commit -m 'added initial todo placeholder'
git push
echo "giving github some time"
hub pull-request "$1" -b Factlink:develop -h Factlink:feature/$1

