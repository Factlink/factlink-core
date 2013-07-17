#!/bin/bash
echo "Running old unit tests"

REPORTFILE=tmp/spec.junit.xml

bundle exec rspec -e Florgy --format RspecJunitFormatter --out $REPORTFILE \
  || echo > TEST_FAILURE

if ! grep -qe '<testcase' < $REPORTFILE ; then
  echo "No testcases found in $REPORTFILE"
  exit 1
fi
