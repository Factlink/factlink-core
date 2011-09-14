#!/bin/bash
cd web-proxy
npm install
cd ../factlink-core
bundle install
rails db:migrate
rake sunspot:solr:start
screen -c script/screen.env
