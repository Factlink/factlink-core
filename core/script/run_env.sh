#!/bin/bash
cd web-proxy
npm install
cd ../factlink-core

mkdir -p log
cd log
touch development.log
touch production.log
touch testserver.log
cd ../

bundle install
rake db:migrate
rake sunspot:solr:start
screen -c script/screen.env
