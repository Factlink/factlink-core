#!/bin/bash
count=`ps x | grep -v grep | grep -c "resque-[0-9]"`

echo "Resque instances running: $count"

if [ "$count" -lt "1" ]; then
  echo "Starting Resque"
  source ~/.bash_profile

  cd /applications/core/current

  export PIDFILE=/home/deploy/resque.pid
  export QUEUE=*

  nohup bundle exec rake environment resque:work &> /applications/core/shared/log/resque.log &
else
  echo "Not starting Resque"
fi
exit 0
