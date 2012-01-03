#!/bin/bash
git clone git@codebasehq.com:factlink/factlink/factlink-chrome-extension.git -b master
git clone git@codebasehq.com:factlink/factlink/factlink-core.git -b master
git clone git@codebasehq.com:factlink/factlink/factlink-js-library.git -b master
git clone git@codebasehq.com:factlink/factlink/web-proxy.git -b master

ln -s factlink-core/config config
gem install bundler
npm install jslint -g
npm install supervisor -g

cd factlink-core
	git checkout develop
	echo -e "master\ndevelop\n\n\n\n\n\n" | git flow init
	gem install bundler
	bundle install
	rake db:migrate
	mkdir -p log
	cd log
		touch development.log
		touch production.log
		touch testserver.log
	cd ..
cd ..


cd web-proxy
	git checkout develop
	echo -e "master\ndevelop\n\n\n\n\n\n" | git flow init
	npm install
cd ..

cd factlink-chrome-extension
	git checkout develop
	echo -e "master\ndevelop\n\n\n\n\n\n" | git flow init
	./release_repo.sh
cd ..

cd factlink-js-library
	git checkout develop
	echo -e "master\ndevelop\n\n\n\n\n\n" | git flow init
	git submodule init
	git submodule update
	make all
cd ..
