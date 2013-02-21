#!/bin/bash
echo "Running unit tests"

OUTPUTFILE=$(mktemp /tmp/unit.XXXX)


bundle exec rspec spec-unit | tee "$OUTPUTFILE"
grep ', 0 failures' $OUTPUTFILE || exit 1

exit
