#!/bin/bash
echo "Running screenshot tests"

OUTPUTFILE=$(mktemp /tmp/screenshot.XXXX)
bundle exec rspec spec/screenshots/ | tee "$OUTPUTFILE"

if ! grep ', 0 failures' $OUTPUTFILE > /dev/null
then
        exit 1
fi

if grep "^0 examples, 0 failures" $OUTPUTFILE > /dev/null
then
        exit 1
fi

exit
