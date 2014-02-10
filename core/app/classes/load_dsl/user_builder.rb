class LoadDsl
  class UserBuilder
    def build username, email, password, full_name
      if User.where(username: username).first
        puts "User #{username} already exists, so new creation skipped"
        return
      end

      u = User.new(
        :username => username,
        :password => password,
        :password_confirmation => password,
        :full_name => full_name || username )
      u.email = email
      u.confirmed_at = DateTime.now
      u.set_up = true
      u.admin = true
      u.seen_tour_step = 'tour_done'
      u.save

      raise_error_if_not_saved(u)
      HandpickedTourUsers.new.add u.id

      u
    end

    def raise_error_if_not_saved u
      return unless u.new_record?

      err_msg = "User #{u.username} could not be created."
      u.errors.each { |e, v| err_msg += "\n#{e.to_s} #{v}" }
      fail err_msg
    end
  end
end
