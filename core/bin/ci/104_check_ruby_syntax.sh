#!/bin/bash

find app/classes | grep -E '\.rb$' | xargs -n1 ruby -wc | grep -v 'Syntax OK' | wc -l


TODO=`find app/classes | grep -E '\.rb$' | xargs -n1 ruby -wc | grep -v 'Syntax OK' | wc -l`

if [ "$TODO" -gt "0" ]; then
  echo "There are warnings in the code"
  exit 1
else
  exit 0
fi
