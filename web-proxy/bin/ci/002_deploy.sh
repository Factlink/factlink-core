#!/bin/bash
source "$HOME/.rvm/scripts/rvm" 
rvm use --default 1.9.2-p290 || exit 1
cap -q testserver deploy || exit 1
exit
