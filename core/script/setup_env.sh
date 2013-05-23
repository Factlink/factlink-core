#!/bin/bash
#abort this script on any error:
set -e

if git status >/dev/null 2>&1; then
	echo `pwd` "appears to be in a git repository.  Aborting - perhaps you are in the hackerone repo already?"
	exit
fi

#below are a few idempotent installer helper functions for git, brew and gem.
#npm install is already idempotent, it needs no helper function.
function cloneRepo {
	if [ ! -d "$1/.git" ]; then 
		echo "cloning factlink $1 repo"
	    git clone "git@github.com:Factlink/$1.git"
		cd $1
	    git checkout master
	    git checkout develop
	    cd ..
	else
		echo "$1 repo already present"
	fi
}
function ensureBrew {
	echo "Ensuring $1 brew is installed and up to date..."
	brew install $1 || brew upgrade $1
}
function ensureGem {
	if gem list $1 -i > /dev/null; then
		echo "$1 already installed; updating..."
		gem update $1
	else
		echo "Installing $1..."
		gem install $1
	fi	
}


if [ ! -d "core/.git" ]; then 
	echo "This script will install the factlink dev environment and all prerequisites."
	echo "The repositories will be cloned to subdirectories within" `pwd`
	if [ -d "hackerone/.git" ]; then
		echo "Warning: the hackerone repo is in this directory, which may be confusing."
	fi
	read -p "Are you sure sure? " resp && echo $resp | egrep "^[yY]"
fi

cloneRepo core
cloneRepo chrome-extension
cloneRepo firefox-extension
cloneRepo js-library
cloneRepo web-proxy
#cloneRepo server-management
#we can't cloneRepo because there's no develop branch!
if [ ! -d "server-management/.git" ]; then 
	git clone "git@github.com:Factlink/server-management.git"
fi

RUBY_VERSION=1.9.3-p392
#warning; p429 and later (including 2.0.0) breaks Time.at Time.zone.now 

if [ -e `which brew` ]; then
    echo "Brew already installed; updating."
    brew update
else
    echo "Installing brew: brew will ask for confirmation."
    ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
fi

#Add a directory for the second redis instance we need for resque: 
mkdir -p /usr/local/var/db/redis-6380

ensureBrew mongo
ensureBrew redis
ensureBrew elasticsearch
ensureBrew node
ensureBrew git-flow
ensureBrew qt
ensureBrew phantomjs

#TODO: java?


ensureBrew rbenv
ensureBrew ruby-build
if egrep -q '^eval "\$\(rbenv init -\)"$' ~/.bash_profile ; then
	echo "rbenv already installed in .bash_profile"
else
	echo "Installing rbenv init script into ~/.bash_profile"
	echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
fi
eval "$(rbenv init -)"
echo "Checking for ruby ${RUBY_VERSION}"
rbenv rehash
if bash -c "rbenv global ${RUBY_VERSION}" ; then
	#NOTE: we need to run the rbenv global TEST in a separate bash instance 
	#because rbenv installs a bash function and due to set -e interaction in can fail.
	echo "Ruby ${RUBY_VERSION} already installed."
else
    echo "Installing ruby ${RUBY_VERSION}..." 
    rbenv install ${RUBY_VERSION}
fi
rbenv global ${RUBY_VERSION}
rbenv rehash

echo 'Installing jslint, supervisor and grunt-cli'

npm install supervisor -g
npm install grunt-cli -g
npm install smoosh -g

if ! type grunt 2>&1 >/dev/null; then
	#/usr/local/share/npm/bin isn't yet in path
	export PATH=$PATH:/usr/local/share/npm/bin
	if ! type grunt 2>&1 >/dev/null; then
		echo "ERROR: Cannot find grunt in path nor in /usr/local/share/npm/bin; exiting."
		exit 1
	fi
	echo 'export PATH=$PATH:/usr/local/share/npm/bin' >> ~/.bash_profile
fi

ensureGem bundler
ensureGem foreman

rbenv rehash

#TODO: REVIEW: ported from old script: why are we symlinking config?
ln -sf core/config config


cd web-proxy
	git flow init -d
	npm install
cd ..

cd chrome-extension
	#TODO: npm install should be in package.json
	npm install yaml
	git flow init -d
	bin/release_repo
cd ..

cd firefox-extension
	git flow init -d
cd ..

cd js-library
	git flow init -d
	npm install
	grunt
cd ..
cd core
	git flow init -d
	bundle install
	mkdir -p log
	cd log
		touch development.log
		touch production.log
		touch testserver.log
	cd ..
	foreman start -f ProcfileServers &
	FOREMAN_PID=$!
	bundle exec rake db:init
	kill ${FOREMAN_PID}
	wait

	# Bootstrap script should be run with current working directory in core
	#note that core's bootstrap script essentially just verifies that things that 
	#setup_env.sh should do were done, so calling it from here only really
	#checkts that there's no mistakes in this script.
	bin/bootstrap 
cd ..
echo
echo
brew outdated
echo "Your factlink development environment is done.  Happy hacking!"
