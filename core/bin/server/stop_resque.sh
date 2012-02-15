PID=`cat ~/resque.pid`

# Check if the process id is in the running processes list
count=`ps x --no-header -eo pid | grep -c $PID`

if [ "$count" -eq "1" ]; then
    cat ~/resque.pid | xargs kill
fi