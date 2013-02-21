#!/bin/bash
echo "Running unit tests"

OUTPUTFILE=$(mktemp /tmp/integration.XXXX)

bundle exec rspec spec | tee "$OUTPUTFILE"

if ! grep ', 0 failures' $OUTPUTFILE > /dev/null
then
        exit 1
fi

if grep "^0 examples, 0 failures" $OUTPUTFILE > /dev/null
then
        exit 1
fi

exit
