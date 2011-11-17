#!/bin/bash
banner "partial content_for check"
ERROR_FILES=`ack content_for -l | grep '/_' | wc -l`

if [ "$ERROR_FILES" -gt "0" ]; then
  echo "Use no content_for in partials."
  echo "Fix those files:"
  ack content_for -l | grep '/_'
  exit 1
else
  exit 0
fi