#!/bin/bash
cd "$( dirname "$0" )"

SHOULD_UPDATE=true

if [[ -n $1 ]]; then
  # We have an option
  if [[ "$1" -eq "no-npm-update" ]];then
    # Do not update
    SHOULD_UPDATE=false
  else
    echo "this script only takes one argument:  no-npm-update"
  fi
fi

if $SHOULD_UPDATE ; then
	npm update
	npm install
	npm install supervisor -g
fi

#read_config.js isn't checked because of eval is evil
./node_modules/jshint/bin/jshint server.js
supervisor ./server.js