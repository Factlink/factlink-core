#!/bin/bash
echo "Running unit tests"

bundle exec rspec --require yarjuf --format JUnit spec-unit --out tmp/spec-unit.junit.xml

bundle exec rspec --require yarjuf --format JUnit spec --out tmp/spec.junit.xml


