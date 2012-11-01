count=`ps x | grep -v grep | grep -c "resque-[0-9]"`

if [ "$count" -lt "1" ]; then
    . /home/deploy/.bash_profile

    cd /applications/core/current

    export PIDFILE=/home/deploy/resque.pid
    export QUEUE=*

    nohup bundle exec rake environment resque:work PIDFILE=$PIDFILE & >> /applications/core/current/log/resque.log 2>&1
fi
exit 0
