#!/bin/bash

rv=0

function check_command_in_path {
  echo -n "Checking for $1 ... "
  which $1 > /dev/null
  success=`echo $?`
  if [ "$success" == "0" ] ; then
    echo '[OK]'
  else
    echo '[FAIL]'
    echo $2
    rv=1
  fi
}

function check_path_exists {
  echo -n "Checking for $1 ... "
  ls $1 > /dev/null
  success=`echo $?`
  if [ "$success" == "0" ] ; then
    echo '[OK]'
  else
    echo '[FAIL]'
    echo $2
    rv=1
  fi
}

echo "For detailed instructions please see https://github.com/Factlink/core/wiki/Setting-up-a-developer-environment"

check_command_in_path 'brew' "Please install Homebrew"

check_command_in_path 'elasticsearch' "Please run brew install elasticsearch"

check_command_in_path 'redis-server' "Please run brew install redis"

check_command_in_path 'mongod' "Please run brew install mongo"

check_path_exists '/usr/local/var/mongodb/' "Please reinstall mongo using brew"

check_path_exists '/usr/local/var/elasticsearch/' "Please reinstall elasticsearch using brew"

check_path_exists '/usr/local/var/log/elasticsearch/' "Please reinstall elasticsearch using brew"

check_path_exists '/usr/local/var/db/redis-6380/' "Please run mkdir /usr/local/var/db/redis-6380"

exit $rv