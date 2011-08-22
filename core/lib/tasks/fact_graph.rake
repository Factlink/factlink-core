namespace :fact_graph do
  task :recalculate => :environment do
    STDOUT.flush
    while true
      print "(#{Time.now.asctime}) recalculating\n"
      FactGraph.recalculate
      print "(#{Time.now.asctime}) sleeping\n"
      sleep 3
    end
  end
end