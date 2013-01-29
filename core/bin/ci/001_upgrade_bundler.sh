#!/bin/bash
echo "Bundle-install"
set -e

gem install bundler

rbenv rehash

bundle install
