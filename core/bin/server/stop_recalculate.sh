#!/bin/bash

ps aux | grep -v grep | grep "fact_graph:recalculate" | awk '{print $2}' | xargs -r kill
ps aux | grep -v grep | grep "channels:recalculate"   | awk '{print $2}' | xargs -r kill