#!/bin/bash
echo "Running integration tests"

OUTPUTFILE=$(tempfile)
bundle exec rspec spec/integration/ | tee "$OUTPUTFILE"
cat "$OUTPUTFILE" | grep ', 0 failures' || exit 1
exit
