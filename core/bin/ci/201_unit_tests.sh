#!/bin/bash
echo "Running old unit tests"

bundle exec rspec --require yarjuf --format JUnit spec --out tmp/spec.junit.xml

