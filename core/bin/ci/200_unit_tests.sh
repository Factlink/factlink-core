#!/bin/bash
echo "Running unit tests"

OUTPUTFILE=$(tempfile)


for dir in `ls unit-spec`; do
  rspec "unit-spec/$dir" | tee "$OUTPUTFILE"
  cat "$OUTPUTFILE" | grep ', 0 failures' || exit 1
done

exit
