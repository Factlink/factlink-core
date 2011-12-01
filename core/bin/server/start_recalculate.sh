#!/bin/bash

# Check if a env is given
if [ -z $1 ] 
then
  echo "Please supply the environment for starting the recalculate."
  echo "Usage:"
  echo "start_recalculate.sh [env]"
  exit 1
fi


RAILS_ENV=$1

# Fact Graph
fact_graph_count=`ps aux | grep -v grep | grep -c 'rake fact_graph:recalculate'`

if [ "$fact_graph_count" -lt "1" ]; then
   cd /applications/factlink-core/current/
   bundle exec rake fact_graph:recalculate RAILS_ENV=$RAILS_ENV > /applications/factlink-core/current/log/fact_graph.log 2>&1 &
fi


# Channels
channels_count=`ps aux | grep -v grep | grep -c 'rake channels:recalculate'`

if [ "$channels_count" -lt "1" ]; then
   cd /applications/factlink-core/current/
   bundle exec rake channels:recalculate RAILS_ENV=$RAILS_ENV > /applications/factlink-core/current/log/channels.log 2>&1 &
fi

exit 0