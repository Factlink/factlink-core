#!/bin/bash
echo "Running screenshot tests"

OUTPUTFILE=$(mktemp /tmp/screenshot.XXXX)
bundle exec rspec spec/screenshots/ | tee "$OUTPUTFILE"
cat "$OUTPUTFILE" | grep ', 0 failures' || exit 1
cat "$OUTPUTFILE" | grep "^0\sexamples,\s0\sfailures" && exit 1
exit
