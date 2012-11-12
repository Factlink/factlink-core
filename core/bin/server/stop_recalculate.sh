#!/bin/bash

if [ -f /home/deploy/recalculate.pid ]; then
  kill -9 `cat /home/deploy/recalculate.pid` && rm -f /home/deploy/recalculate.pid
fi
