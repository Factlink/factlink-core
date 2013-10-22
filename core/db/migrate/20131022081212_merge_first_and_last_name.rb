class MergeFirstAndLastName < Mongoid::Migration
  def self.up
    User.all.each do |u|
      puts "first name:#{u[:first_name]}; last name: #{u[:last_name]}"
      u.full_name = u[:first_name] + ' ' + u[:last_name]
      puts "full name:#{u[:full_name]}"
      u.remove_attribute(:first_name)
      u.remove_attribute(:last_name)
      u.save!
    end
  end

  def self.down
    fail "This is a destructive migration."
  end
end
