#!/bin/bash
echo "Running acceptance tests"

rm -rf tmp/capybara/

REPORTFILE=tmp/spec-acceptance.junit.xml
OUTPUTFILE=rspec-acceptance-output.log

function do_tests {
  bundle exec rspec --format RspecJunitFormatter spec/acceptance/ \
    --out $REPORTFILE \
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
