class RemoveConversationsData < Mongoid::Migration
  def self.up
    User.all.each do |user|
      user.remove_attribute(:conversation_ids)
    end
    Mongoid.default_session[:conversations].drop
    Mongoid.default_session[:messages].drop
  end

  def self.down
  end
end
