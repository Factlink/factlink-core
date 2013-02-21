#!/bin/bash
echo "Running Javascript tests"

OUTPUTFILE=$(mktemp /tmp/javascript.XXXX)

bundle exec rake konacha:run | tee "$OUTPUTFILE"

cat "$OUTPUTFILE" | grep ', 0 failed' || exit 1

exit
