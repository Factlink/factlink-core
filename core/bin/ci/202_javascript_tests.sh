#!/bin/bash
echo "Running Javascript tests"

OUTPUTFILE=$(mktemp /tmp/javascript.XXXX)

bundle exec rake konacha:run | tee "$OUTPUTFILE"

if ! grep ', 0 failed' $OUTPUTFILE > /dev/null
then
        exit 1
fi

exit
