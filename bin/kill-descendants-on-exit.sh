pids=''
get_pids() {
  if [[ `uname` == 'Darwin' ]]; then
    # OS X
    tree=`(pstree $$)`
    pids=`echo $tree | grep -o '[=-] [0-9]\+' | grep -o '[0-9]\+' | grep -v $$`
  else
    # Linux
    tree=`(pstree -p $$)`
    pids=`echo $tree | grep -o '([0-9]\+)' | grep -o '[0-9]\+' | grep -v $$`
  fi
}

onexit() {
  echo 'Terminating descendants...'
  for i in {1..100}
  do
    get_pids
    if [[ `echo $pids | wc -w` -lt 4 ]]; then
      echo 'Exiting with # processes still running:'
      echo $pids | wc -w
      break
    fi

    for pid in $pids; do kill $pid 2>/dev/null; done;
    sleep 0.1
  done

  get_pids
  for pid in $pids; do kill -9 $pid 2>/dev/null; done;
}
noop_func() { :; }
trap onexit EXIT
trap noop_func SIGINT SIGTERM INT QUIT TERM
