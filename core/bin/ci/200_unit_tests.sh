#!/bin/bash
echo "Running unit tests"

bundle exec rspec -e Florgy --format RspecJunitFormatter spec-unit \
 --out tmp/spec-unit.junit.xml || echo > TEST_FAILURE
