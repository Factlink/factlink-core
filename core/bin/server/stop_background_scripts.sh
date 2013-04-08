#!/bin/bash

for x in {0..120}
do
  echo -n "."

  # When monit is already busy quiting OR starting, it can throw an error message:
  # monit: action failed -- Other action already in progress -- please try again later
  # We don't care for that message, so we just pipe every message to /dev/null
  sudo monit stop resque > /dev/null 2>&1
  sudo monit stop recalculate > /dev/null 2>&1

  i=`sudo monit status | grep --after-context=1 --extended-regexp 'recalculate|resque' | grep --extended-regexp 'not monitored$' | wc --lines`
  if [ "$i" -eq "2" ]; then
    echo "\nDone."; # Nice little line-break
    exit 0
  fi

  sleep 1
done

echo "Execution failed"
exit 1
