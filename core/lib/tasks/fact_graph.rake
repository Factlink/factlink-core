namespace :fact_graph do
  task :recalculate => :environment do
    FactGraph.recalculate
  end
end