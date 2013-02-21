#!/bin/bash
echo "Running acceptance tests"

OUTPUTFILE=$(mktemp /tmp/acceptance.XXXX)
bundle exec rspec spec/acceptance/ | tee "$OUTPUTFILE"

grep ', 0 failures' $OUTPUTFILE || exit 1

echo "First test succeeded";

grep "^0 examples, 0 failures" $OUTPUTFILE && exit 1

echo "Second test succeeded";

exit
