#!/bin/bash

# unfortunately, under some circumstances rspec may never terminate
# when that happens, it retains open ports and DB activity, and this
# will break all kinds of stuff.  Since each slave never runs more than
# one build at a time, we just kill this slave's CI ruby processes.
echo Killing zombies...
killall -w -9 -u `whoami` ruby


# go to the root of the git repo
cd `dirname $0`
cd ..

rm -f tmp/*.junit.xml
rm -f TEST_FAILURE

./script/set-status.sh "$GIT_COMMIT" pending "$BUILD_URL" "$BUILD_TAG" > github_pending_response.json


export RUBY_HEAP_MIN_SLOTS=1000000
export RUBY_HEAP_SLOTS_INCREMENT=1000000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_GC_MALLOC_LIMIT=100000000
export RUBY_HEAP_FREE_MIN=500000


for action in bin/ci/*.sh; do
  banner $action;
  time /bin/bash "$action"
  if [ "$?" -gt "0" ] ; then
    ./script/set-status.sh "$GIT_COMMIT" error "$BUILD_URL" "$BUILD_TAG" > github_error_response.json
    exit 1
  fi
  if [ -f TEST_FAILURE ] ; then
    ./script/set-status.sh "$GIT_COMMIT" failure "$BUILD_URL" "$BUILD_TAG" > github_failure_response.json
  fi
done
if [ -f TEST_FAILURE ] ; then
  exit
fi
./script/set-status.sh "$GIT_COMMIT" success "$BUILD_URL" "$BUILD_TAG"  > github_success_response.json
