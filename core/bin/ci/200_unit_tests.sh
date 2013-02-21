#!/bin/bash
echo "Running unit tests"

OUTPUTFILE=$(mktemp /tmp/unit.XXXX)


bundle exec rspec spec-unit | tee "$OUTPUTFILE"
cat "$OUTPUTFILE" | grep ', 0 failures' || exit 1

exit
