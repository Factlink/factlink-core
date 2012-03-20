namespace :fact_graph do
  task :recalculate => :environment do

    `echo "#{Process.pid}" > /var/lock/monit/fact_graph/fact_graph_recalculate.pid`
    `echo "#{Process.ppid}" > /var/lock/monit/fact_graph/fact_graph_recalculate.ppid`


    STDOUT.flush
    sleep_time = 59
    puts "now recalculating with interval of #{sleep_time} seconds"
    $stdout.flush
    while true
      puts "now recalculating factgraph"
      $stdout.flush
      FactGraph.recalculate
      sleep sleep_time
    end
  end
end