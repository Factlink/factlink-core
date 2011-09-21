#!/bin/bash
npm install
jsl -process server.js -process read_config.js 
node ./server.js