#!/bin/bash

ps aux | grep -v grep | grep "fact_graph:recalculate" | awk '{print $2}' | xargs -r kill

fact_graph_count=1
while [ "$fact_graph_count" -gt "0" ]; do
  sleep 1
  fact_graph_count=`ps aux | grep -v grep | grep -c 'rake fact_graph:recalculate'`
done