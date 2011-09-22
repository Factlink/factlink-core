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
echo "Available stages: testserver, production"


echo "\n"
read -p "You will deploy to the $stage environment. Are you sure? [Y/n] "
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "\nDeploying"

		echo "\n\n\n=== factlink-core ==="
		cd factlink-core
		cap -v $stage deploy
		
		echo "\n\n\n=== factlink-js-library ==="
		cd ../factlink-js-library
		cap -v $stage deploy
		
		echo "\n\n\n=== factlink-chrome-extension ==="
		cd ../factlink-chrome-extension
		cap -v $stage deploy
		
		echo "\n\n\n=== web-proxy ==="
		cd ../web-proxy
		cap -v $stage deploy
		
		echo "\nDeployed to $stage environment."
		exit 0
else
	echo "\nExit without deploy. Have a nice day =)\n"
	exit 0

fi