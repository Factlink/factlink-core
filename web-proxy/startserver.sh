#!/bin/bash
cd "$( dirname "$0" )"
npm install
jsl -process server.js -process read_config.js && node ./server.js