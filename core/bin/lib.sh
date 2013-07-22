#!/bin/bash

export CREDENTIALS="jenkins:b0rst1g3b4z3n"
export JENKINS_HOSTNAME="ci-factlink.inverselink.com"
export JENKINS_URL="https://$JENKINS_HOSTNAME"

jenkins_job_for_feature_name() {
  CAMEL_CASED_BRANCH_NAME=`echo $1 | ruby -pe 'require "rails"; $_.gsub!(/-/, "_");$_="#{$_.camelize}"'`
  echo "Feature${CAMEL_CASED_BRANCH_NAME}Core"
}

jenkins_job_for_feature_branch() {
  feature_name=`echo $1 | perl -pe 's#feature/##'`
  jenkins_job_for_feature_name "$feature_name"
}


current_branch_name() {
  git rev-parse --abbrev-ref HEAD
}
