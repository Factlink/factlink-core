#!/bin/bash
echo "Running unit tests"

REPORTFILE=tmp/spec-unit.junit.xml

bundle exec rspec -e Florgy --format RspecJunitFormatter spec-unit \
 --out $REPORTFILE || echo > TEST_FAILURE

if ! grep -qe '<testcase' < $REPORTFILE ; then
  echo "No testcases found in $REPORTFILE"
  exit 1
fi
