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


if [ "$DEPLOY_SERVER" == "production" ] ; then
  export SUPPRESS_TESTING=1
  export SUPPRESS_METRICS=1
fi
if [ "$DEPLOY_SERVER" == "staging" ] ; then
  export SUPPRESS_METRICS=1
fi

# print environment
env
ruby --version
which ruby

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
