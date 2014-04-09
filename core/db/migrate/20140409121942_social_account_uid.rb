class SocialAccountUid < Mongoid::Migration
  def self.up
    SocialAccount.all.each do |social_account|
      # triggers revalidation and thus saves omniauth_obj_id
      social_account.update_omniauth_obj!(social_account[:omniauth_obj])
    end
  end

  def self.down
  end
end
