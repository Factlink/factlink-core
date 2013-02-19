#!/bin/bash
ENVIRONMENT=`cat /etc/factlink-environment`;

PROXY_PATH=/applications/web-proxy/current/;

echo "starting node proxy using forever";

cd $PROXY_PATH;

export NODE_ENV=$ENVIRONMENT;

npm install;
forever start server.js;
