#!/bin/bash

MY_DIR=`dirname $0`
. $MY_DIR/lib.sh

git status | grep 'Changes not staged for commit'>/dev/null
if [ $? -eq 0 ]; then
  echo 'Please stash any changes before starting a new feature'
  exit 1
fi

if [ "$1" == "" ]; then
  echo "please specify the name of the feature (without spaces)"
  exit 1
fi

set -e

echo "starting feature $1"
git flow feature start $1
git flow feature publish $1
git commit -m 'empty commit' --allow-empty
git push origin "feature/$1"
echo "giving github some time"
hub pull-request "$1" -b Factlink:develop -h Factlink:feature/$1

echo "Setting up Jenkins build"
curl --user $CREDENTIALS $JENKINS_URL/job/FeatureTemplateCore/config.xml > new_config.xml
perl -pi -e "s/PUT_FEATURE_HERE/"$1"/; s#(<disabled>)true(</disabled>)#\1false\2#" new_config.xml
JOB_NAME=`jenkins_job_for_feature_name "$1"`
curl --user $CREDENTIALS -H "Content-Type: text/xml" -s --data "`cat new_config.xml`" "$JENKINS_URL/createItem?name=$JOB_NAME"
rm new_config.xml
