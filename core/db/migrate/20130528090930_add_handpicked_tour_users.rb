class AddHandpickedTourUsers < Mongoid::Migration
  def self.up
    [ 
      "Jens", 
      "martijn", 
      "tomdev", 
      "Jk", 
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
      "SocialRevolution", 
      "salvador", 
      "annie", 
    ].each do |username|
      user = User.find username
      if user 
        Pavlov.command :"users/add_handpicked_user", user.id.to_s
      end
    end
  end
end
