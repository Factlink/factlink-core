#!/bin/bash
echo "Running unit tests"

bundle exec rspec --require yarjuf --format JUnit spec-unit --out tmp/spec-unit-report.xml

bundle exec rspec --require yarjuf --format JUnit spec --out tmp/spec-report.xml


