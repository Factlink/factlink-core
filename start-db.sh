#!/bin/bash
onexit() {
  pids=`(pstree -p $$)`
  pids=`echo $pids| grep -o '([0-9]\+)' | grep -o '[0-9]\+' |grep -v $$`
  for pid in $pids; do kill $pid 2>/dev/null; done;
  echo "Waiting for children to exit..."
  sleep 1
  pids=`(pstree -p $$)`
  pids=`echo $pids| grep -o '([0-9]\+)' | grep -o '[0-9]\+' |grep -v $$`
  for pid in $pids; do kill -9 $pid 2>/dev/null; done;
}
trap onexit SIGINT SIGTERM EXIT INT QUIT TERM
cd "$( dirname "${BASH_SOURCE[0]}" )"

(cd core && elasticsearch -f -Des.config=config/developmentservers/elasticsearch.yml -Des.cluster.name="elasticsearch_$(hostname)"  || kill $$)  2>&1| perl -pe "s/^/\x1b[0;31m[elasticsearch] \x1b[0m/" &
(cd core && redis-server config/developmentservers/redis.conf  || kill $$)  2>&1| perl -pe "s/^/\x1b[0;32m[redis] \x1b[0m/" &
(cd core && redis-server config/developmentservers/redis-for-tests.conf  || kill $$)  2>&1| perl -pe "s/^/\x1b[0;33m[redisfortests] \x1b[0m/" &
(cd core && redis-server config/developmentservers/redis-resque.conf  || kill $$)  2>&1| perl -pe "s/^/\x1b[0;34m[resqueredis] \x1b[0m/" &
(cd core && mongod --config config/developmentservers/mongo.conf  || kill $$)  2>&1| perl -pe "s/^/\x1b[0;35m[mongo] \x1b[0m/" &
(cd local_development && bundle exec mailcatcher -fv || kill $$) 2>&1| perl -pe "s/^/\x1b[0;36m[mailcatcher] \x1b[0m/" &
wait
