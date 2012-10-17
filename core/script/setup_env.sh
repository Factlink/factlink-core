#!/bin/bash
git clone git@github.com:Factlink/chrome-extension.git -b master
git clone git@github.com:Factlink/firefox-extension -b master
git clone git@github.com:Factlink/core.git -b master
git clone git@github.com:Factlink/js-library.git -b master
git clone git@github.com:Factlink/web-proxy.git -b master
git clone git@github.com:Factlink/server-management -b master

ln -s core/config config
gem install bundler
sudo npm install jslint -g
sudo npm install supervisor -g

cd core
	# Bootstrap script should be run with path in core
	bin/bootstrap || exit 1

	git checkout develop
	echo -e "master\ndevelop\n\n\n\n\n\n" | git flow init
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
	npm install yaml
	git checkout develop
	echo -e "master\ndevelop\n\n\n\n\n\n" | git flow init
	bin/release_repo
cd ..

cd firefox-extension
	git checkout develop
	echo -e "master\ndevelop\n\n\n\n\n\n" | git flow init
cd ..

cd js-library
	git checkout develop
	echo -e "master\ndevelop\n\n\n\n\n\n" | git flow init
	npm install -g grunt
	npm install
	grunt
cd ..

echo -e "Start by entering:"
echo -e "foreman start -f ProcfileServers"
echo -e "foreman start"
