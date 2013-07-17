#!/bin/bash
echo "Running acceptance tests"

REPORTFILE=tmp/spec-acceptance.junit.xml

bundle exec rspec -e Florgy --format RspecJunitFormatter spec/acceptance/ \
  --out $REPORTFILE \
  || echo > TEST_FAILURE


if ! grep -qe '<testcase' < $REPORTFILE ; then
  echo "No testcases found in $REPORTFILE"
  exit 1
fi
