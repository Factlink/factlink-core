#!/bin/bash
echo "Running Javascript tests"

REPORTFILE=tmp/konacha.junit.xml
OUTPUTFILE=konacha-output.log

function do_tests {
  bundle exec rake konacha:load_poltergeist konacha:run \
    2>&1 | tee $OUTPUTFILE
  KONACHA_STATUS=${PIPESTATUS[0]}
}


do_tests
if grep -qe 'PhantomJS has crashed.' < $OUTPUTFILE ; then
  echo "Detected random fail, retrying"
  do_tests
fi

exit $KONACHA_STATUS
