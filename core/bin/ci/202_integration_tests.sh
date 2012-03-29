#!/bin/bash
echo "Running integration tests"
source "$HOME/.rvm/scripts/rvm"
rvm use --default 1.9.2-p290 || exit 1

OUTPUTFILE=$(tempfile)
bundle exec rspec spec/integration/ | tee "$OUTPUTFILE"
cat "$OUTPUTFILE" | grep ', 0 failures' || exit 1
exit