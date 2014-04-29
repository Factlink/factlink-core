#!/bin/bash
cd `dirname $0`/..
ls tmp/capybara/ | egrep -v -e '-diff\.png|screenshot_201' | grep '\.png' | xargs -n 1 -I '{}' cp 'tmp/capybara/{}' spec/screenshots/screenshots/
