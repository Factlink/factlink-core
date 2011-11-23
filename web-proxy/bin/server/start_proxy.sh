#!/bin/bash
ENVIRONMENT=`cat /etc/factlink-environment`;

CONFIG_PATH=/applications/factlink-core/current/config/;
PROXY_PATH=/applications/web-proxy/current/;

echo "starting node proxy using forever";

cd $PROXY_PATH;

export CONFIG_PATH=/applications/factlink-core/current/config/;
export NODE_ENV=$ENVIRONMENT;

npm install;
forever start server.js;