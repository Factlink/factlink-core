#!/bin/bash
echo "Running unit tests"

OUTPUTFILE=$(mktemp /tmp/integration.XXXX)

bundle exec rspec spec | tee "$OUTPUTFILE"

grep ', 0 failures' $OUTPUTFILE || exit 1
grep "^0 examples, 0 failures" $OUTPUTFILE && exit 1

exit
