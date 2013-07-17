#!/bin/bash
echo "Running Javascript tests"

REPORTFILE=tmp/konacha.junit.xml

bundle exec rake konacha:load_poltergeist konacha:run \
  || echo > TEST_FAILURE


if ! grep -qe '<testcase' < $REPORTFILE ; then
  echo "FAILING BUILD: No testcases found in $REPORTFILE"
  exit 1
fi
