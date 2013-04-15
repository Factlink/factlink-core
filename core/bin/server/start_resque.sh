#!/bin/bash
count=`ps x | grep -v grep | grep -c "resque-[0-9]"`

if [ "$count" -lt "1" ]; then
  . /etc/profile
  . /home/deploy/.bash_profile

  cd /applications/core/current

  export PIDFILE=/home/deploy/resque.pid
  export QUEUE=*

  nohup bundle exec rake environment resque:work &>> /applications/core/shared/log/resque.log &
fi
exit 0
