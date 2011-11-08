#!/bin/bash
echo "Starting deploy..."
source "$HOME/.rvm/scripts/rvm"
rvm use --default 1.9.2-p290
cap -q testserver deploy
exit
