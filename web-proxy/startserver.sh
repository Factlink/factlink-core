#!/bin/bash
cd "$( dirname "$0" )"
npm install
#read_config.js isn't checked because of eval is evil
jslint server.js


supervisor ./server.js