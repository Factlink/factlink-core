class CreatedByIdString < Mongoid::Migration
  def self.up
    SocialAccount.all.each do |social_account|
      # Convert from Moped::BSON::ObjectId to String
      social_account.user_id = social_account.user_id
      social_account.save!
    end
  end

  def self.down
  end
end
