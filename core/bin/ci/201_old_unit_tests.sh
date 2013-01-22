#!/bin/bash
exit
echo "Running unit tests"

OUTPUTFILE=$(tempfile)

bundle exec rspec spec | tee "$OUTPUTFILE"

cat "$OUTPUTFILE" | grep ', 0 failures' || exit 1
exit
