#!/bin/bash

echo "Usage: sh deploy.sh [stage]"
echo "Available stages: staging, production\n"

# Check the stage
if test -z "$1"
then
  echo "Please provide stage"
  exit 1
else
  stage="$1"
fi

read -p "You will deploy to the $stage environment. Are you sure? [Y/n] "
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "\nDeploying"

    echo "\n\n\n=== factlink-core ==="
    cd core
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
