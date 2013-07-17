#!/bin/bash
echo "Running acceptance tests"

bundle exec rspec -e Florgy --format RspecJunitFormatter spec/acceptance/ \
  --out tmp/spec-acceptance.junit.xml \
  || echo > TEST_FAILURE

