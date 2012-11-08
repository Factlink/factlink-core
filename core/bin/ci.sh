#!/bin/bash

# go to the root of the git repo
cd `dirname $0`
cd ..

for action in bin/ci/*.sh; do
  banner $action;
  time /bin/bash "$action"
  if [ "$?" -gt "0" ] ; then exit 1; fi
done
