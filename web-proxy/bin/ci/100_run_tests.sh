#!/bin/bash
npm install || exit 1
npm update || exit 1
export NODE_ENV=testserver;
node_modules/expresso/bin/expresso || exit 1
exit