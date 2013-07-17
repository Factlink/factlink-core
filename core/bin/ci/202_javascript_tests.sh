#!/bin/bash
echo "Running Javascript tests"

REPORTFILE=tmp/konacha.junit.xml

bundle exec rake konacha:load_poltergeist konacha:run \
  || echo > TEST_FAILURE
