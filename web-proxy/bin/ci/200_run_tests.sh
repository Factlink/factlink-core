#!/bin/bash
export NODE_ENV=test;
node_modules/expresso/bin/expresso -b || exit 1
exit
