#!/bin/bash
onexit() {
  kill -2 $(jobs -p)
  kill $(jobs -p)
  echo "Waiting for children to exit..."
  sleep 1.1
  kill -9 0
}
trap onexit SIGINT SIGTERM EXIT INT QUIT TERM
cd "$( dirname "${BASH_SOURCE[0]}" )"

(./start-db.sh ; kill $$) &
(./start-web.sh ; kill $$) &
(cd js-library; grunt default watch ; kill $$) &
wait
