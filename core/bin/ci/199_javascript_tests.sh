#!/bin/bash
echo "Running javascript tests"
source "$HOME/.rvm/scripts/rvm"
rvm use --default 1.9.2-p290 || exit 1
bundle exec rake templates:create || exit 1
bundle exec jasmine-headless-webkit || exit 1
exit