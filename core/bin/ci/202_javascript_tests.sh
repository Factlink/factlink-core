#!/bin/bash
echo "Running Javascript tests"

OUTPUTFILE=$(mktemp /tmp/javascript.XXXX)

for i in {1..5}
do
  bundle exec rake konacha:load_poltergeist konacha:run 2>&1 \
   | grep -vE '^(Compiled|method=GET|Served asset)' \
   | tee "$OUTPUTFILE"

  ERROR1='Timed out waiting for response to'
  ERROR2='method .method_missing. called on terminated object'
  if grep --extended-regex "$ERROR1|$ERROR2" $OUTPUTFILE > /dev/null
  then
    echo "Detected random fail, retrying (retry $i)"
  else
    break
  fi
done
