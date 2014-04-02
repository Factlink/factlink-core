#!/bin/bash
cd "$( dirname "${BASH_SOURCE[0]}" )"
. bin/kill-descendants-on-exit.sh

(./start-db.sh ; kill $$) &
(./start-web.sh ; kill $$) &
wait
