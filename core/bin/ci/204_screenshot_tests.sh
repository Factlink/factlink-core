#!/bin/bash
echo "Running screenshot tests"

OUTPUTFILE=$(mktemp /tmp/screenshot.XXXX)
bundle exec rspec spec/screenshots/ | tee "$OUTPUTFILE"

grep ', 0 failures' $OUTPUTFILE || exit 1

echo "First test succeeded";

grep "^0 examples, 0 failures" $OUTPUTFILE && exit 1

echo "Second test succeeded";

exit
