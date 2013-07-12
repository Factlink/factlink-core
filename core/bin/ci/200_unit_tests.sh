#!/bin/bash
echo "Running unit tests"

bundle exec rspec --format RspecJunitFormatter spec-unit --out tmp/spec-unit.junit.xml
