#!/bin/bash
echo "Running unit tests"

OUTPUTFILE=$(mktemp /tmp/integration.XXXX)

bundle exec rspec spec | tee "$OUTPUTFILE"

cat "$OUTPUTFILE" | grep ', 0 failures' || exit 1
cat "$OUTPUTFILE" | grep "^0\sexamples,\s0\sfailures" && exit 1
exit
