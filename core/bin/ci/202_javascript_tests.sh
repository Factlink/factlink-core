#!/bin/bash
echo "Running Javascript tests"

OUTPUTFILE=$(mktemp /tmp/javascript.XXXX)

bundle exec rake  konacha:load_poltergeist konacha:run 2>&1 \
 | grep -vE '^(Compiled|method=GET|Served asset)' \
 | tee "$OUTPUTFILE"

if grep 'Timed out waiting for response to' $OUTPUTFILE > /dev/null
then
  echo detected random fail
fi

if ! grep ', 0 failed' $OUTPUTFILE > /dev/null
then
        exit 1
fi

exit
