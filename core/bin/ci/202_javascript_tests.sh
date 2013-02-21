#!/bin/bash
echo "Running Javascript tests"

OUTPUTFILE=$(mktemp /tmp/javascript.XXXX)

bundle exec rake konacha:run | tee "$OUTPUTFILE"

grep ', 0 failed' $OUTPUTFILE || exit 1

exit
