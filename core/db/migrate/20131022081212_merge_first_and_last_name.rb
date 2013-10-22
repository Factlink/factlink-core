class MergeFirstAndLastName < Mongoid::Migration
  def self.up
    User.all.each do |u|
      if u[:full_name].blank?
        u.full_name = "#{u[:first_name]} #{u[:last_name]}"
        u.remove_attribute(:first_name)
        u.remove_attribute(:last_name)
        u.save(validate: false)
      end
    end
  end

  def self.down
    fail "This is a destructive migration."
  end
end
