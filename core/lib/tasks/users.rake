namespace :user do
  task :add, [:user, :email, :password]  => :environment do |t, args|
    FactlinkApi::UserManager.create_user args.user, args.email, args.password
  end
end
