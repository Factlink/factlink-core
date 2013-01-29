#!/bin/bash
echo "Running Javascript tests"

OUTPUTFILE=$(tempfile)

xvfb-run bundle exec jasmine-headless-webkit | tee "$OUTPUTFILE"

cat "$OUTPUTFILE" | grep ', 0 failures' || exit 1
exit
