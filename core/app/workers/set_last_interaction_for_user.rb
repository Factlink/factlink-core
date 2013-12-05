class SetLastInteractionForUser

  @queue = :mmm_user_operations

  def self.perform(user_id, timestamp)
    user = User.find(user_id)
    user.last_interaction_at = Time.at(timestamp).to_datetime
    user.save
  end

end
