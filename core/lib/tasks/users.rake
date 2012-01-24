namespace :user do
  task :add, [:user, :email, :password]  => :environment do |t, args|
    User.create({ username: args.user,
                  email: args.email,
                  password: args.password,
                  confirmed_at: DateTime.now
    })
  end
end
