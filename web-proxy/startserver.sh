#!/bin/bash
cd "$( dirname "$0" )"
npm install
npm install supervisor -g

#read_config.js isn't checked because of eval is evil
./node_modules/jshint/bin/hint server.js

supervisor ./server.js