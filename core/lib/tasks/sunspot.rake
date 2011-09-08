namespace :sunspot do
  desc "indexes searchable models"
  task :index => :environment do
    [FactData, User].each {|model| Sunspot.index!(model.all)}
  end
  
end