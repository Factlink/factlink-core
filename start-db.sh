#!/bin/bash
onexit() {
  kill -2 $(jobs -p)
  kill $(jobs -p)
  echo "Waiting for children to exit..."
  sleep 1
  kill -9 0
}
cd "$( dirname "${BASH_SOURCE[0]}" )"/core
trap onexit SIGINT SIGTERM EXIT INT QUIT TERM
(elasticsearch -f -Des.config=config/developmentservers/elasticsearch.yml -Des.cluster.name="elasticsearch_$(hostname)"  || kill $$)  2>&1| perl -pe "s/^/\x1b[0;31m[elasticsearch] \x1b[0m/" &
(redis-server config/developmentservers/redis.conf  || kill $$)  2>&1| perl -pe "s/^/\x1b[0;32m[redis] \x1b[0m/" &
(redis-server config/developmentservers/redis-for-tests.conf  || kill $$)  2>&1| perl -pe "s/^/\x1b[0;33m[redisfortests] \x1b[0m/" &
(redis-server config/developmentservers/redis-resque.conf  || kill $$)  2>&1| perl -pe "s/^/\x1b[0;34m[resqueredis] \x1b[0m/" &
(mongod --config config/developmentservers/mongo.conf  || kill $$)  2>&1| perl -pe "s/^/\x1b[0;35m[mongo] \x1b[0m/" &
(bundle exec mailcatcher -fv || kill $$) 2>&1| perl -pe "s/^/\x1b[0;36m[mailcatcher] \x1b[0m/" &
wait
