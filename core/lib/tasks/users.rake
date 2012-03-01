namespace :user do
  task :add, [:user, :email, :password]  => :environment do |t, args|
    u = User.new({ username: args.user,

                  password: args.password,
                  confirmed_at: DateTime.now
    })
    u.email = args.email
    u.save
    if(u.errors.size > 0)
      msg = "Failed to import "
      u.errors.each { |e, v| msg += "#{e.to_s} #{v}" }
      fail(msg)
    end
  end
end
