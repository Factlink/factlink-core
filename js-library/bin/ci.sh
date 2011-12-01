#!/bin/bash

# go to the root of the git repo
cd `dirname $0`
cd ..

export GIT_BRANCH=`git branch | grep '*' | perl -pe 's/\* //'`

for action in bin/ci/*.sh; do
  banner $action;
  /bin/bash $action
  if [ "$?" -gt "0" ] ; then exit 1; fi
done
