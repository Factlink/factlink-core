#!/bin/bash

[ -z "$SUPPRESS_METRICS" ] || exit 0

echo "Running Rails Best Practices"

bundle exec rails_best_practices --silent
