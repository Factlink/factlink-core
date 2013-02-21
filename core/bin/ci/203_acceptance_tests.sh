#!/bin/bash
echo "Running acceptance tests"

OUTPUTFILE=$(mktemp /tmp/acceptance.XXXX)
bundle exec rspec spec/acceptance/ | tee "$OUTPUTFILE"

if ! grep ', 0 failures' $OUTPUTFILE > /dev/null
then
        exit 1
fi

if grep "^0 examples, 0 failures" $OUTPUTFILE > /dev/null
then
        exit 1
fi

exit
