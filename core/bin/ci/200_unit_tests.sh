#!/bin/bash

[ -z $SUPPRESS_TESTING ] || exit 0
echo "Running unit tests"

REPORTFILE=tmp/spec-unit.junit.xml
bundle exec rspec --format RspecJunitFormatter spec-unit \
  --out $REPORTFILE \
  || touch TEST_FAILURE

if ! grep -qe '<testcase' < $REPORTFILE ; then
  echo "FAILING BUILD: No testcases found in $REPORTFILE"
  exit 1
fi
