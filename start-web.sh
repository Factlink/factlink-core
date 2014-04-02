#!/bin/bash
cd "$( dirname "${BASH_SOURCE[0]}" )"
. bin/kill-descendants-on-exit.sh

(cd core && bundle exec rake environment resque:work 'QUEUE=*'  || kill $$)  2>&1| perl -pe "s/^/\x1b[0;31m[worker] \x1b[0m/" &
(cd core && bundle exec thin start || kill $$)  2>&1| perl -pe "s/^/\x1b[0;32m[webserver] \x1b[0m/" &
(cd core && bundle exec script/static.rb || kill $$)  2>&1| perl -pe "s/^/\x1b[0;33m[static] \x1b[0m/" &
(cd proxy && bundle exec ruby server.rb -p 8080 -e development || kill $$) 2>&1| perl -pe "s/^/\x1b[0;34m[proxy] \x1b[0m/" &
(cd testserver && ruby server.rb || kill $$)  2>&1| perl -pe "s/^/\x1b[0;35m[testserver] \x1b[0m/" &
(cd js-library && grunt && grunt watch; kill $$)  2>&1| perl -pe "s/^/\x1b[0;36m[testserver] \x1b[0m/" &
wait
