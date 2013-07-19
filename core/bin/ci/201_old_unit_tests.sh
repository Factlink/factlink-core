#!/bin/bash
echo "Running old unit tests"

REPORTFILE=tmp/spec.junit.xml

bundle exec rspec --format RspecJunitFormatter --out $REPORTFILE \
  || touch TEST_FAILURE

if ! grep -qe '<testcase' < $REPORTFILE ; then
  echo "FAILING BUILD: No testcases found in $REPORTFILE"
  exit 1
fi
