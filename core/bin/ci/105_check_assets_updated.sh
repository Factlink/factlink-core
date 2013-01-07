#!/bin/bash

CURRENT_MD5=`cat config/locales/* | md5sum | perl -pe 's/\s*-\s*//'`
RECORDED_MD5=`cat app/assets/javascripts/globals/globals.coffee.erb  | grep '# MD5' | perl -pe 's/.*:\s*//'`

if [ "$CURRENT_MD5" != "$RECORDED_MD5" ]; then
  echo "Please update the MD5 in globals.coffee.erb to '$CURRENT_MD5'"
  exit 1
else
  exit 0
fi
