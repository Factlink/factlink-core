namespace :fact_graph do
  task :recalculate => :environment do
    STDOUT.flush
    sleep_time = 2
    puts "now recalculating with interval of #{sleep_time} seconds"  
    while true
      #print "(#{Time.now.asctime}) recalculating FactGraph\n"
      FactGraph.recalculate
      #print "(#{Time.now.asctime}) sleeping\n"
      sleep sleep_time
    end
  end
end

namespace :channels do
  task :recalculate => :environment do
    sleep_time = 2
    puts "now recalculating with interval of #{sleep_time} seconds"  
    while true
      #print "(#{Time.now.asctime}) recalculating channels\n"
      Channel.recalculate_all
      #print "(#{Time.now.asctime}) sleeping\n"
      sleep sleep_time
    end
  end
end