class IdentitiesToSocialAccount < Mongoid::Migration
  def self.up
    User.all.each do |user|
      if user[:identities] and user[:identities]['twitter']
        user.social_account('twitter').save_omniauth_obj! user[:identities]['twitter']
      end

      if user[:identities] and user[:identities]['facebook']
        user.social_account('facebook').save_omniauth_obj! user[:identities]['facebook']
      end
    end
  end

  def self.down
  end
end
