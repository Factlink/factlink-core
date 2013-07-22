#!/bin/bash
echo "Running unit tests"

REPORTFILE=tmp/spec-unit.junit.xml
OUTPUTFILE=rspec-unit-output.log

function do_tests {
  bundle exec rspec --format RspecJunitFormatter spec-unit \
    --out $REPORTFILE \
    2>&1 | tee $OUTPUTFILE \
    || touch TEST_FAILURE
}


do_tests
if grep -qe 'PhantomJS has crashed.' < $OUTPUTFILE ; then
  echo "Detected random fail, retrying"
  do_tests
fi



if ! grep -qe '<testcase' < $REPORTFILE ; then
  echo "FAILING BUILD: No testcases found in $REPORTFILE"
  exit 1
fi
