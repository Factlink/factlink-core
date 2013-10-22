#!/bin/bash

[ -z $SUPPRESS_METRICS ] || exit 0

echo "Running Cane"

bundle exec cane
