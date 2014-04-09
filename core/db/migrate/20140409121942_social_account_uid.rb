class SocialAccountUid < Mongoid::Migration
  def self.up
    SocialAccount.all.each do |social_account|
      social_account.save! # triggers revalidation and thus saves omniauth_obj_id
    end
  end

  def self.down
  end
end
