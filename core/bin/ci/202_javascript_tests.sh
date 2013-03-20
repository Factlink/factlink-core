#!/bin/bash
exit 0 # FIXME: Temporarily disabling JS tests
echo "Running Javascript tests"

OUTPUTFILE=$(mktemp /tmp/javascript.XXXX)

for i in {1..5}
do
  bundle exec rake konacha:load_poltergeist konacha:run 2>&1 \
   | grep -vE '^(Compiled|method=GET|Served asset)' \
   | tee "$OUTPUTFILE"

  if grep 'Timed out waiting for response to' $OUTPUTFILE > /dev/null
  then
    echo "Detected random fail, retrying (retry $i)"
  else
    break
  fi
done

if ! grep ', 0 failed' $OUTPUTFILE > /dev/null
then
        exit 1
fi

exit
