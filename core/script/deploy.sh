#!/bin/bash

# Check the stage
if test -z "$1" 
then
	stage="testserver"
else
  stage="$1"
fi

echo "Usage: sh deploy.sh [stage]"
echo "Default stage: testserver"
echo "Available stages: testserver, production\n"

read -p "You will deploy to the $stage environment. Are you sure? [Y/n] "
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "\nDeploying"

		cd factlink-core
		cap $stage deploy
		
		cd ../factlink-js-library
		cap $stage deploy
		
		cd ../factlink-chrome-extension
		cap $stage deploy
		
		cd ../web-proxy
		cap $stage deploy
		
		echo "\nDeployed to $stage environment."
		exit 0
else
	echo "\nExit without deploy. Have a nice day =)\n"
	exit 0
fi