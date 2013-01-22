#!/bin/bash
exit
echo "Running screenshot tests"

OUTPUTFILE=$(tempfile)
bundle exec rspec spec/screenshots/ | tee "$OUTPUTFILE"
cat "$OUTPUTFILE" | grep ', 0 failures' || exit 1
exit
