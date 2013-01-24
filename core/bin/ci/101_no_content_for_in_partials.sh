#!/bin/bash
exit
echo "partial content for check"

ERROR_FILES=`ack-grep content_for -l | grep "/_" | wc -l`
echo $ERROR_FILES
if [ "$ERROR_FILES" -gt "0" ]; then
  echo "Use no content_for in partials."
  echo "Fix those files:"
  ack-grep content_for -l | grep '/_'
  exit 1
else
  exit 0
fi
