#!/bin/bash
cd web-proxy
npm install

cd ../factlink-core
bundle install
rake db:migrate
rake sunspot:solr:start
screen -c script/screen.env
