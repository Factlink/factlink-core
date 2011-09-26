#!/bin/bash
cd "$( dirname "$0" )"
npm install
#read_config isn't checked because of eval is evil
jslint server.js && node ./server.js