#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"
bin/ensure-postgres-socket-dir.sh
. bin/kill-descendants-on-exit.sh

(postgres -D 'tmp/postgres' -c 'synchronous_commit=off'|| kill $$)  2>&1| perl -pe "s/^/\x1b[0;35m[postgres] \x1b[0m/" &
(cd local_development && bundle exec mailcatcher -fv || kill $$) 2>&1| perl -pe "s/^/\x1b[0;36m[mailcatcher] \x1b[0m/" &
wait
