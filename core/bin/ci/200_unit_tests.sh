#!/bin/bash
echo "Running unit tests"

bundle exec rspec --require yarjuf --format JUnit spec-unit --out tmp/spec-unit.xml

bundle exec rspec --require yarjuf --format JUnit spec --out tmp/spec.xml

echo "Aborting to keep things fast..."
exit 10 #intentional failure for now
