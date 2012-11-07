#!/bin/bash
echo "Running unit tests"

OUTPUTFILE=$(tempfile)


for dir in `ls spec-unit`; do
  rspec "spec-unit/$dir" | tee "$OUTPUTFILE"
  cat "$OUTPUTFILE" | grep ', 0 failures' || exit 1
done

exit
