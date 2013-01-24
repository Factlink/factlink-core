#!/bin/bash

find app/classes | grep -E '\.rb$' | xargs -n1 ruby -wc 2>&1 | grep -v 'Syntax OK'


TODO=`find app/classes | grep -E '\.rb$' | xargs -n1 ruby -wc 2>&1 | grep -v 'Syntax OK' | wc -l`

if [ "$TODO" -gt "0" ]; then
  echo "There are warnings in the code"
  exit 1
else
  exit 0
fi
