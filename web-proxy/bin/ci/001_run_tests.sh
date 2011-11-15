#!/bin/bash
npm install || exit 1
export NODE_ENV=testserver; export CONFIG_PATH=/home/jetty/jobs/factlink-core/workspace/config/; node_modules/expresso/bin/expresso || exit 1
exit