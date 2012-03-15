#!/bin/bash
echo "Running integration tests"
source "$HOME/.rvm/scripts/rvm"
rvm use --default 1.9.2-p290 || exit 1
bundle exec  rspec spec/integration/integration_spec.rb
exit