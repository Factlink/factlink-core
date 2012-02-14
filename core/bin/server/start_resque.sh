. ~/.bash_profile

cd /applications/factlink-core/current

export PIDFILE=~/resque.pid
export QUEUE=*

bundle exec rake environment resque:work PIDFILE=$PIDFILE > /applications/factlink-core/current/log/resque.log 2>&1 &