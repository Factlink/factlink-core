#!/bin/bash

# go to the root of the git repo
cd `dirname $0`
cd ..

for action in bin/ci/*.sh; do
  banner $action;
  time=`time /bin/bash $action`
  echo "Action $action timing:"
  echo "$time"
  if [ "$?" -gt "0" ] ; then exit 1; fi
done
