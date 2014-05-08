#!/bin/bash
cd "$( dirname "${BASH_SOURCE[0]}" )"
. bin/kill-descendants-on-exit.sh

(bundle exec thin start || kill $$)  2>&1| perl -pe "s/^/\x1b[0;32m[webserver] \x1b[0m/" &
(cd proxy && bundle exec ruby server.rb -p 8080 -e development || kill $$) 2>&1| perl -pe "s/^/\x1b[0;34m[proxy] \x1b[0m/" &
(cd testserver && ruby server.rb || kill $$)  2>&1| perl -pe "s/^/\x1b[0;35m[testserver] \x1b[0m/" &
(cd js-library && grunt server; kill $$)  2>&1| perl -pe "s/^/\x1b[0;36m[testserver] \x1b[0m/" &
wait
