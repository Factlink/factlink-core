class Following < ActiveRecord::Base
  attr_accessible :followee_id, :follower_id, :created_at, :updated_at
end
