#!/bin/bash
echo "Running unit tests"

bundle exec rspec spec-unit --format RspecJunitFormatter  --out tmp/rspec-unit.xml

echo "Aborting to keep things fast..."
exit 10 #intentional failure for now
