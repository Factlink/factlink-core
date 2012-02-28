class ChangeUserNameToUserAgreesTosName < Mongoid::Migration
  def self.up
    say_with_time "Changing user.name to user.agrees_tos_name" do
      User.all.each do |user|
        user.agrees_tos_name = u.name
        user.unset(:name)
        user.save
      end
    end
  end

  def self.down
  end
end