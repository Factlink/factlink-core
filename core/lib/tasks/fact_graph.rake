namespace :fact_graph do
  task :recalculate => :environment do
    STDOUT.flush
    while true
      print "(#{Time.now.asctime}) recalculating FactGraph\n"
      FactGraph.recalculate
      print "(#{Time.now.asctime}) sleeping\n"
      sleep 3
    end
  end
end

namespace :channels do
  task :recalculate => :environment do
    while true
      print "(#{Time.now.asctime}) recalculating channels\n"
      Channel.recalculate_all
      print "(#{Time.now.asctime}) sleeping\n"
      sleep 3
    end
  end
end