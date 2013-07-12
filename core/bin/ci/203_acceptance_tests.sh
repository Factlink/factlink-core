#!/bin/bash
echo "Running acceptance tests"

OUTPUTFILE=$(mktemp /tmp/acceptance.XXXX)

for i in {1..2}
do
  bundle exec rspec --format RspecJunitFormatter spec/acceptance/ \
    --out tmp/spec-acceptance.junit.xml  | tee "$OUTPUTFILE"

  if grep 'Capybara::Poltergeist::DeadClient' $OUTPUTFILE > /dev/null
  then
    echo "Detected random fail, retrying (retry $i)"
  else
    break
  fi
done


if ! grep ', 0 failures' $OUTPUTFILE > /dev/null
then
        exit 1
fi

if grep "^0 examples, 0 failures" $OUTPUTFILE > /dev/null
then
        exit 1
fi

exit
