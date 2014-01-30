#!/bin/bash
onexit() {
  kill -2 $(jobs -p)
  kill $(jobs -p)
  echo "Waiting for children to exit..."
  sleep 1
  kill -9 0
}
trap onexit SIGINT SIGTERM EXIT INT QUIT TERM

(cd core && bundle exec rake environment resque:work 'QUEUE=*'  || kill $$)  2>&1| perl -pe "s/^/\x1b[0;31m[worker] \x1b[0m/" &
(cd core && bundle exec thin start || kill $$)  2>&1| perl -pe "s/^/\x1b[0;32m[webserver] \x1b[0m/" &
(cd core && bundle exec script/static.rb || kill $$)  2>&1| perl -pe "s/^/\x1b[0;33m[static] \x1b[0m/" &
(web-proxy/startserver.sh no-npm-update || kill $$)  2>&1| perl -pe "s/^/\x1b[0;34m[proxy] \x1b[0m/" &
(cd core && bundle exec resque-web -F -L config/initializers/resque.rb || kill $$)  2>&1| perl -pe "s/^/\x1b[0;35m[resqueweb] \x1b[0m/" &

wait
