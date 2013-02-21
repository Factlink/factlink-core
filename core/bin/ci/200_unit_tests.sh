#!/bin/bash
echo "Running unit tests"

OUTPUTFILE=$(mktemp /tmp/unit.XXXX)


bundle exec rspec spec-unit | tee "$OUTPUTFILE"

if ! grep ', 0 failures' $OUTPUTFILE > /dev/null
then
        exit 1
fi

exit
