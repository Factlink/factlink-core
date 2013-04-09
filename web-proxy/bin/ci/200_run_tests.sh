#!/bin/bash
export NODE_ENV=testserver;
node_modules/expresso/bin/expresso || exit 1
exit
