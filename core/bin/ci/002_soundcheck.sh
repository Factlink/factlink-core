#!/bin/bash
banner "Tests"
source "$HOME/.rvm/scripts/rvm"
rvm use --default 1.9.2-p290 || exit 1
bundle exec rspec spec || exit 1
exit 