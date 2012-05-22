#!/bin/bash
echo "TODO check"
pwd

ack-grep -c --ignore-dir=coverage  --ignore-dir=bin --ignore-dir=tmp '(TODO|HACK)'

TODO=`ack-grep -c --ignore-dir=coverage  --ignore-dir=bin --ignore-dir=tmp '(TODO|HACK)' | perl -pe 's/.*://' | perl -pe 's/\n/+/smg' | perl -pe 's/$/0\n/'  | bc`
TOO_MUCH_TODO=50
echo "$TODO TODO's"

if [ "$TODO" -gt "$TOO_MUCH_TODO" ]; then
  echo "TOO MUCH TODO's!!!!"
  echo "Please do them"
  exit 1
else
  exit 0
fi
