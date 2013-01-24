#!/bin/bash

echo "Running unit tests"

OUTPUTFILE=$(tempfile)


bundle exec rspec spec-unit | tee "$OUTPUTFILE"
cat "$OUTPUTFILE" | grep ', 0 failures' || exit 1

exit
