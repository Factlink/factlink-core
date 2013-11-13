class RemoveTosFields < Mongoid::Migration
  def self.up
    User.all.each do |u|
      u.remove_attribute(:agrees_tos)
      u.remove_attribute(:agrees_tos_name)
      u.remove_attribute(:agreed_tos_on)
      u.save(validate: false)
    end
  end

  def self.down
    fail "This is a destructive migration."
  end
end
