#TODO remove me and all my references (also in usermanagement in servermanagement)
module FactlinkApi
  class UserManager
    def self.create_user(user, email, password)
      u = User.new({ username: user,
                    password: password,
      })
      u.email = email
      u.confirmed_at = DateTime.now
      u.save
      if(u.errors.size > 0)
        msg = "Failed to import "
        u.errors.each { |e, v| msg += "#{e.to_s} #{v}" }
        fail(msg)
      end
    end
  end
end
