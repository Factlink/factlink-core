#!/bin/bash

if [ -f /home/deploy/resque.pid ]; then
  kill -9 `cat /home/deploy/resque.pid` && rm -f /home/deploy/resque.pid
fi
