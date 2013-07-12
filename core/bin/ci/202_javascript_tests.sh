#!/bin/bash
echo "Running Javascript tests"

bundle exec rake konacha:load_poltergeist konacha:run \
  || echo > TEST_FAILURE
