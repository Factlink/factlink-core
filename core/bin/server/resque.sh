#!/bin/bash
case $1 in
   start)
      echo "Starting Resque"
      sh /applications/core/current/bin/server/start_resque.sh || exit 1
      ;;
    stop)
      echo "Stopping Resque"
      sh /applications/core/current/bin/server/stop_resque.sh || exit 1
      ;;
    *)
      echo "usage: xyz {start|stop}" ;;
esac
exit 0