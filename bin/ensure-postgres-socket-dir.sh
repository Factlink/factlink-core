#!/bin/bash
if [[ ! -d /var/run/postgresql/ ]]; then
  echo Need to create /var/run/postgresql/
  sudo mkdir -p /var/run/postgresql/
  sudo chmod 777 /var/run/postgresql/ # this is necessary to mitigate ubuntu's unhandy compiled-in constant postgres socket dir.
fi
