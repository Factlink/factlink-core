onexit() {
  echo 'Terminating descendants...'
  for i in {1..100}
  do
    pids=`(pstree -p $$)`
    pids=`echo $pids| grep -o '([0-9]\+)' | grep -o '[0-9]\+' |grep -v $$`
    if [[ `echo $pids | wc -w` < 3 ]]; then break; fi

    for pid in $pids; do kill $pid 2>/dev/null; done;
    sleep 0.1
  done

  pids=`(pstree -p $$)`
  pids=`echo $pids| grep -o '([0-9]\+)' | grep -o '[0-9]\+' |grep -v $$`
  for pid in $pids; do kill -9 $pid 2>/dev/null; done;
}
noop_func() { :; }
trap onexit EXIT
trap noop_func SIGINT SIGTERM INT QUIT TERM
