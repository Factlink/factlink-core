#!/bin/bash
echo "Running Javascript tests"

OUTPUTFILE=$(tempfile)

xvfb-run bundle exec jasmine-headless-webkit | tee "$OUTPUTFILE"

cat "$OUTPUTFILE" | grep ', 0 failures' || exit 1

bundle exec rake konacha:run | tee "$OUTPUTFILE"

cat "$OUTPUTFILE" | grep ', 0 failed' || exit 1

exit
