#!/bin/bash
git clone -b develop git@codebasehq.com:factlink/factlink/factlink-chrome-extension.git
git clone -b develop git@codebasehq.com:factlink/factlink/factlink-core.git
git clone -b develop git@codebasehq.com:factlink/factlink/factlink-js-library.git
git clone -b develop git@codebasehq.com:factlink/factlink/web-proxy.git

ln -s factlink-core/config config
gem install bundle

cd factlink-core
bundle install
rake db:migrate
cd ..

cd web-proxy
npm install
cd ..

cd factlink-chrome-extension
./build_manifest.sh
cd ..

cd factlink-js-library
git submodule init
git submodule update
make all
cd ..
