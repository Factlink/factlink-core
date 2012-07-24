#!/bin/bash
function check_command_in_path {
  echo -n "Checking for $1 ... "
  (which $1 > /dev/null && echo '[OK]') || (echo '[FAIL]' && echo $2)

}

check_command_in_path 'elasticsearch' "Please run brew install elasticsearch"

