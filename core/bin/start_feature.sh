#!/bin/bash
CREDENTIALS="jenkins:b0rst1g3b4z3n"
JENKINS_URL="https://ci-factlink.inverselink.com"

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
echo "$1" > "changelog/$1.md"
git add "changelog/$1.md"
git commit -m 'added changelog placeholder'
git push origin "feature/$1"
echo "giving github some time"
hub pull-request "$1" -b Factlink:develop -h Factlink:feature/$1

echo "Setting up Jenkins build"
curl --user $CREDENTIALS $JENKINS_URL/job/FeatureTemplateCore/config.xml > new_config.xml
perl -pi -e "s/PUT_FEATURE_HERE/"$1"/; s#(<disabled>)true(</disabled>)#\1false\2#" new_config.xml
CAMEL_CASED_BRANCH_NAME=`echo $1 | ruby -pe 'require "rails"; $_.gsub!(/-/, "_");$_="#{$_.camelize}"'`
curl --user $CREDENTIALS -H "Content-Type: text/xml" -s --data "`cat new_config.xml`" "$JENKINS_URL/createItem?name=Feature${CAMEL_CASED_BRANCH_NAME}Core"
rm new_config.xml
