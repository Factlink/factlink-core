#!/bin/bash
git clone git@codebasehq.com:factlink/factlink/factlink-chrome-extension.git
git clone git@codebasehq.com:factlink/factlink/factlink-core.git
git clone git@codebasehq.com:factlink/factlink/factlink-js-library.git
git clone git@codebasehq.com:factlink/factlink/web-proxy.git

ln -s factlink-core/config config
gem install bundler
npm install jslint -g

cd factlink-core
	git checkout develop
	echo -e "master\ndevelop\n\n\n\n\nv\n" | git flow init
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
	echo -e "master\ndevelop\n\n\n\n\nv\n" | git flow init
	npm install
cd ..

cd factlink-chrome-extension
	git checkout develop
	echo -e "master\ndevelop\n\n\n\n\nv\n" | git flow init
	./release_repo.sh
cd ..

cd factlink-js-library
	git checkout develop
	echo -e "master\ndevelop\n\n\n\n\nv\n" | git flow init
	git submodule init
	git submodule update
	make all
cd ..
