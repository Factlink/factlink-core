#!/bin/bash
exit
echo "Check for simple XSS vulnerability. We want our value attributes to be quoted with double quotes."
echo $PATH

COUNT=`ack-grep -c --ignore-dir=coverage --ignore-dir=bin --ignore-dir=tmp "(value=')" | perl -pe 's/.*://' | perl -pe 's/\n/+/smg' | perl -pe 's/$/0\n/' | bc`
TOO_MUCH_VALUE=1
echo "$COUNT \"value='\"'s"

if [ "$COUNT" -gt "$TOO_MUCH_VALUE" ]; then
  echo "TOO MUCH VALUE=''s!!!!"
  echo "Please do them"
  exit 1
else
  exit 0
fi
