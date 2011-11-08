#!/bin/bash
echo "Start running bundle install and tests"
source "$HOME/.rvm/scripts/rvm"
rvm use --default 1.9.2-p290
gem install bundler
bundle install
exit
