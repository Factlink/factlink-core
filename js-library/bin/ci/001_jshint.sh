#!/bin/bash
npm install jshint || exit 1
ls src/js/*.js | grep -vE '(intro|outro)' | xargs node_modules/jshint/bin/hint || exit 1
node_modules/jshint/bin/hint src/js/lib/*.js || exit 1
node_modules/jshint/bin/hint src/js/scripts/*.js || exit 1
exit
