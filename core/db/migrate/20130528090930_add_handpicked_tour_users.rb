class AddHandpickedTourUsers < Mongoid::Migration
  def self.up
    [
      "Jens",
      "martijn",
      "tomdev",
      "Vikingmobile",
      "merijn",
      "jobert",
      "janpaul",
      "mark",
      "melvin",
      "michiel",
      "RSO",
      "lbekkema",
      "Nathan",
      "JJoos",
      "EamonNerbonne",
      "annie"
    ].each do |username|
      user = User.find username
      if user
        Pavlov.old_command :"users/add_handpicked_user", user.id.to_s
      end
    end
  end
end
