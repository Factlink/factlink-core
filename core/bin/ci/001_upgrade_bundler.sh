#!/bin/bash
echo "Bundle-install"

gem install bundler || exit 1
gem install soundcheck
gem install jasmine-headless-webkit

rbenv rehash

bundle install || exit 1

exit
