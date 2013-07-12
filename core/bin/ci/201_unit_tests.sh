#!/bin/bash
echo "Running old unit tests"

bundle exec rspec --format RspecJunitFormatter --out tmp/spec.junit.xml

