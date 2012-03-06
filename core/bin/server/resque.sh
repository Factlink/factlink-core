#!/bin/bash
case $1 in
   start)
      sh /applications/factlink-core/current/bin/server/start_resque.sh
      ;;
    stop)
<<<<<<< HEAD
      sh /applications/factlink-core/current/bin/server/stop_resque.sh
      ;;
=======
      sh /applications/factlink-core/current/bin/server/stop_resque.sh ;;
>>>>>>> 024485a... Wrapper script to start and stop Resque
    *)
      echo "usage: xyz {start|stop}" ;;
esac
exit 0