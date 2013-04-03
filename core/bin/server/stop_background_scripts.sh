#!/bin/bash

sudo monit stop resque
sudo monit stop recalculate

for x in {0..120}; do
  i=`sudo monit status | grep --after-context=1 --extended-regexp 'recalculate|resque' | grep --extended-regexp 'Not monitored' | wc --lines`
  if $i == 2; break; end
  sleep 1
done
