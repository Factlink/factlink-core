#!/bin/bash
count=`ps x | grep -v grep | grep -c 'rake fact_graph:recalculate'`

if [ "$count" -lt "1" ]; then
  . /etc/profile
  . /home/deploy/.bash_profile

  cd /applications/core/current

  export PIDFILE=/home/deploy/recalculate.pid
  export NEWRELIC_DISPATCHER="FactGraph recalculate"

  nohup nice -n 10 bundle exec rake environment fact_graph:recalculate &>> /applications/core/current/log/fact_graph.log &
fi
exit 0
