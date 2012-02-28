namespace :redis do
  task :remove_temp_keys => :environment do

    sleep_time = 3

    40.times do
       1000.times { key = Ohm.redis.randomkey; (Ohm.redis.del key) if /(^~.*)|(\*UNION\*)/.match(key)}
       sleep sleep_time
    end
  end
end