#!/bin/bash

##
# This script starts fact_graph:recalculate using Monit.

for i in {1..3}
do

  echo "Starting fact_graph:recalculate, try #$i:"

  sudo nice -n 10 /usr/sbin/monit start recalculate

  # Check the exit status
  if [ "$?" -eq "0" ]; then

    # Previous command was a success. I can safely exit
    echo "Succes. Exiting now"
    exit 0

  else
    # Failed to start
    if [ "$i" -eq "3" ]; then
      # Failed 3 times. Probabaly better to stop trying
      echo "Failed 3 times. Exiting..."
      exit 1
    else
      echo "Failed"
    fi
  fi
done

exit 0
