namespace :sunspot do
  desc "indexes searchable models"
  task :index => :environment do
    [FactData].each {|model| Sunspot.index!(model.all)}
  end
  
end