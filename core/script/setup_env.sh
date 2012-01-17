#!/bin/bash
git clone git@github.com:Factlink/chrome-extension.git -b master
git clone git@github.com:Factlink/core.git -b master
git clone git@github.com:Factlink/js-library.git -b master
git clone git@github.com:Factlink/web-proxy.git -b master
git clone git@github.com:Factlink/server-management -b master
git clone git@github.com:Factlink/homepage -b master


ln -s core/config config
gem install bundler
npm install jslint -g
npm install supervisor -g

cd core
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

cd chrome-extension
	git checkout develop
	echo -e "master\ndevelop\n\n\n\n\n\n" | git flow init
	./release_repo.sh
cd ..

cd js-library
	git checkout develop
	echo -e "master\ndevelop\n\n\n\n\n\n" | git flow init
	git submodule init
	git submodule update
	make modules
cd ..
