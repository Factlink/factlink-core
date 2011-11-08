#!/bin/bash

# Fact Graph
fact_graph_count=`ps aux | grep -c 'rake fact_graph:recalculate'`

if [ "$fact_graph_count" -lt "2" ]; then
   cd /applications/factlink-core/current/
   nohup /usr/local/rvm/bin/rake fact_graph:recalculate RAILS_ENV=testserver > /applications/factlink-core/current/log/fact_graph.log 2>&1 &
fi


# Channels
channels_count=`ps aux | grep -c 'rake channels:recalculate'`

if [ "$channels_count" -lt "2" ]; then
   cd /applications/factlink-core/current/
   nohup /usr/local/rvm/bin/rake channels:recalculate RAILS_ENV=testserver > /applications/factlink-core/current/log/channels.log 2>&1 &
fi

exit 0