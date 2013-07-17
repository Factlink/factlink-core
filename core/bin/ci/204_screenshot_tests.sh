#!/bin/bash
echo "Running screenshot tests"

REPORTFILE=tmp/spec-screenshots.junit.xml

bundle exec rspec --format RspecJunitFormatter spec/screenshots/ \
  --out $REPORTFILE \
  || echo > TEST_FAILURE


if ! grep -qe '<testcase' < $REPORTFILE ; then
  echo "FAILING BUILD: No testcases found in $REPORTFILE"
  exit 1
fi
