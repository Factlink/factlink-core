namespace :users do
  namespace :create do
    task :avatar => :environment do
      User.all.each do |u|
        u.set_avatar_from_twitter
      end
    end
  end
end