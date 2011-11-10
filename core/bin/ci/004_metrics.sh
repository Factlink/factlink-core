#!/bin/bash
banner "Metrics"
source "$HOME/.rvm/scripts/rvm"
rvm use --default 1.9.2-p290
bundle exec rake metrics:all
exit