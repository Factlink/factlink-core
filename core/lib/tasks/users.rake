namespace :user do
  task :add, [:user, :email, :password]  => :environment do |t, args|
    u = User.new({ username: args.user,
                  email: args.email,
                  password: args.password,
                  confirmed_at: DateTime.now
    })
    u.save
    if(u.errors.size > 0)
      msg = "Failed to import "
      u.errors.each { |e| msg += e.to_s }
      fail(msg)
    end
  end
end
