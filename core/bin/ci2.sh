#!/bin/bash

# go to the root of the git repo
cd `dirname $0`
cd ..

for action in bin/ci2/*.sh; do
  banner $action;
  /bin/bash $action
  if [ "$?" -gt "0" ] ; then exit 1; fi
done
