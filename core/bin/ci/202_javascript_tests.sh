#!/bin/bash
echo "Running unit tests"

OUTPUTFILE=$(tempfile)

xvfb-run jasmine-headless-webkit | tee "$OUTPUTFILE"

cat "$OUTPUTFILE" | grep ', 0 failures' || exit 1
exit
