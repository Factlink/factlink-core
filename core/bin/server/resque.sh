#!/bin/bash
case $1 in
   start)
      sh /applications/core/current/bin/server/start_resque.sh
      ;;
    stop)
      sh /applications/core/current/bin/server/stop_resque.sh
      ;;
    *)
      echo "usage: xyz {start|stop}" ;;
esac
exit 0
