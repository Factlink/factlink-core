#!/bin/bash
echo "Running Javascript tests"

REPORTFILE=tmp/konacha.junit.xml
OUTPUTFILE=konacha-output.log

function do_tests {
  bundle exec rake konacha:load_poltergeist konacha:run \
    2>&1 | tee $OUTPUTFILE
  test ${PIPESTATUS[0]} -eq 0 || touch TEST_FAILURE
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
