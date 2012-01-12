#!/bin/bash
echo "Running tests"
source "$HOME/.rvm/scripts/rvm"
rvm use --default 1.9.2-p290 || exit 1
export RUN_METRICS=TRUE
bundle exec rspec spec || exit 1
exit 