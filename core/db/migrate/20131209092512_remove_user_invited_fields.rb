class RemoveUserInvitedFields < Mongoid::Migration
  def self.up
    User.all.map(&:id).each do |user_id|
      Resque.enqueue MigrateUnsetInviteFields, user_id
    end
  end

  def self.down
  end
end
