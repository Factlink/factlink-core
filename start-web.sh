#!/bin/bash
onexit() {
  pids=`(pstree -p $$)`
  pids=`echo $pids| grep -o '([0-9]\+)' | grep -o '[0-9]\+' |grep -v $$`
  for pid in $pids; do kill $pid 2>/dev/null; done;
  echo "Waiting for children to exit..."
  sleep 1
  pids=`(pstree -p $$)`
  pids=`echo $pids| grep -o '([0-9]\+)' | grep -o '[0-9]\+' |grep -v $$`
  for pid in $pids; do kill -9 $pid 2>/dev/null; done;
}
trap onexit SIGINT SIGTERM EXIT INT QUIT TERM
cd "$( dirname "${BASH_SOURCE[0]}" )"

(cd core && bundle exec rake environment resque:work 'QUEUE=*'  || kill $$)  2>&1| perl -pe "s/^/\x1b[0;31m[worker] \x1b[0m/" &
(cd core && bundle exec thin start || kill $$)  2>&1| perl -pe "s/^/\x1b[0;32m[webserver] \x1b[0m/" &
(cd core && bundle exec script/static.rb || kill $$)  2>&1| perl -pe "s/^/\x1b[0;33m[static] \x1b[0m/" &
(cd proxy && bundle exec ruby server.rb -p 8080 -e development || kill $$) 2>&1| perl -pe "s/^/\x1b[0;34m[proxy] \x1b[0m/" &
(cd testserver && ruby server.rb || kill $$)  2>&1| perl -pe "s/^/\x1b[0;35m[testserver] \x1b[0m/" &
(cd js-library && grunt && grunt watch; kill $$)  2>&1| perl -pe "s/^/\x1b[0;36m[testserver] \x1b[0m/" &
wait
