#!/bin/bash

count=`ps x | grep -v grep | grep -c 'rake fact_graph:recalculate'`

if [ "$count" -lt "1" ]; then
    cd /applications/core/current

    export PIDFILE=/home/deploy/recalculate.pid

    export NEWRELIC_DISPATCHER="FactGraph recalculate"
    nohup /usr/local/rbenv/shims/bundle exec rake environment fact_graph:recalculate PIDFILE=$PIDFILE >> /applications/core/current/log/fact_graph.log 2>&1
fi
exit 0
