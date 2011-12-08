#!/bin/bash
echo "Bundle-install"

source "$HOME/.rvm/scripts/rvm" || exit 1
rvm use --default 1.9.2-p290 || exit 1
gem install bundler || exit 1
gem install soundcheck
bundle install || exit 1
exit
