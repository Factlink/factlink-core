#!/bin/bash
count=`ps x | grep -v grep | grep -c 'rake fact_graph:recalculate'`

if [ "$count" -lt "1" ]; then
  . /etc/profile
  . /home/deploy/.bash_profile

  cd /applications/core/current

  export NRCONFIG=/applications/core/current/config/newrelic.yml
  export NEW_RELIC_LOG=/applications/core/shared/log/newrelic_agent.log

  export PIDFILE=/home/deploy/recalculate.pid
  export NEWRELIC_DISPATCHER="FactGraph recalculate"

  nohup nice -n 10 bundle exec rake environment fact_graph:recalculate &>> /applications/core/current/log/fact_graph.log &
fi
exit 0
