#!/bin/bash

# Note: alternative to using ruby -wc we could also use rubocop

find app/classes -name'*.rb$' | xargs -n1 ruby -wc 2>&1 | grep -v 'Syntax OK'


TODO=`find app/classes -name '*.rb' | xargs -n1 ruby -wc 2>&1 | grep -v 'Syntax OK' | wc -l | perl -pe 's/\s*//'`

if [ "$TODO" -gt "0" ]; then
  echo "There are warnings in the code"
  exit 1
else
  exit 0
fi
