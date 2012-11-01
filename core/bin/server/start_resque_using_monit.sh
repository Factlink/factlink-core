#!/bin/bash

##
# This script starts Resque using Monit.

for i in {1..3}
do

  echo "Starting Resque, try #$i:"

  sudo /usr/sbin/monit start resque

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
