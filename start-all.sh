#!/bin/bash
cd "$( dirname "${BASH_SOURCE[0]}" )"
bin/ensure-postgres-socket-dir.sh
. bin/kill-descendants-on-exit.sh

(./start-db.sh ; kill $$) &
bin/bootstrap --no-db-start
(./start-web.sh ; kill $$) &
wait
