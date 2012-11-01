#!/bin/bash
case $1 in
   start)
      echo "Starting fact_graph:recalculate" 1>&2
      sh /applications/core/current/bin/server/start_recalculate.sh || exit 1
      ;;
    stop)
      echo "Stopping fact_graph:recalculate" 1>&2
      sh /applications/core/current/bin/server/stop_recalculate.sh || exit 1
      ;;
    *)
      echo "usage: xyz {start|stop}" ;;
esac
exit 0
