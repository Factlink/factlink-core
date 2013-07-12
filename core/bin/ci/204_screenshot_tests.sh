#!/bin/bash
echo "Running screenshot tests"


bundle exec rspec --format RspecJunitFormatter spec/screenshots/ \
  --out tmp/spec-screenshots.junit.xml \
  || echo > TEST_FAILURE
