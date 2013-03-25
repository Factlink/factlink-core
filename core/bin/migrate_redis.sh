#!/usr/bin/env bash
set -e

SSH_USER="jan" # user to ssh to machines with

#ssh jan@testserver.factlink.com "cat /etc/redis/6379.conf | grep dbfilename;ls -d1 /var/lib/redis/6379/*.*;cat /etc/redis/6380.conf | grep dbfilename;ls -d1 /var/lib/redis/6380/*.*;"
if [ "testserver" == `hostname` ]; then
  IP1="89.188.27.172" # redis server
  IP2="89.188.27.174" # redis resque server
  FILENAME="/var/lib/redis/6379/testserver_dump.rdb"
  FILENAME_RESQUE="/var/lib/redis/6380/testserver_dump_6380.rdb"
fi

if [ "staging" == `hostname` ]; then
  IP1="88" # redis server
  IP2="88" # redis resque server
  FILENAME="/var/lib/redis/6379/staging_dump.rdb"
  FILENAME_RESQUE="/var/lib/redis/6380/staging_dump_6380.rdb"
fi

if [ "production"  == `hostname` ]; then
  IP1="88" # redis server
  IP2="88" # redis resque server
  FILENAME="/var/lib/redis/6379/production_dump.rdb"
  FILENAME_RESQUE="/var/lib/redis/6380/staging_dump_6380.rdb"
fi

#stop redis on external servers
ssh -t "$SSH_USER@$IP1" "sudo monit stop redis"
ssh -t "$SSH_USER@$IP2" "sudo monit stop redis"

#stop recalc
monit stop recalculate || exit 1

#factlink uit
monit stop nginx || exit 1

#redis uit (kan dit met monit)
monit stop redis || exit 1
monit stop redis-6380 || exit 1

# scp to external servers
sudo scp "$FILENAME" "$SSH_USER@$IP1:~/dump-6379.rdb" || exit 1
ssh -t "$SSH_USER@$IP1" "sudo mv ~/dump-6379.rdb /var/lib/redis/dump-6379.rdb"
sudo scp "$FILENAME_RESQUE" "$SSH_USER@$IP2:~/dump-6379.rdb" || exit 1
ssh -t "$SSH_USER@$IP2" "sudo mv ~/dump-6379.rdb /var/lib/redis/dump-6379.rdb"

# start redis op external servers
ssh -t "$SSH_USER@$IP1" "sudo monit start redis"
ssh -t "$SSH_USER@$IP2" "sudo monit start redis"

# update config
echo "development:
  redis:
    hostname: localhost
    port: 6381

test:
  redis:
    hostname: localhost
    port: 6379

testserver:
  redis:
    hostname: $IP1
    port: 6379

staging:
  redis:
    hostname: $IP1
    port: 6379

production:
  redis:
    hostname: $IP1
    port: 6379" > '/applications/core/current/config/redis.yml'


echo "development: localhost:6380
test: localhost:6380
testserver: $IP2:6379
staging: $IP2:6379
production: $IP2:6379" > '/applications/core/current/config/resque.yml'

# factlink aan
monit start nginx

# start recalc
monit start recalculate
