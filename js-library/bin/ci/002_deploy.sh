#!/bin/bash
echo "Deploying js-library to testserver"
source "$HOME/.rvm/scripts/rvm"
rvm use --default 1.9.2-p290
cap -v testserver deploy
exit
