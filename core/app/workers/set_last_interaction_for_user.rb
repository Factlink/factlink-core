class SetLastInteractionForUser < Resque::ThrottledJob

  throttle can_run_every: 1.minutes

  @queue = :user_operations

  def self.identifier(*args)
    args = *args
    user_id = args[0]

    "set_last_interaction:user_id:#{user_id}" # unique identifier for job/user
  end

  def self.perform(user_id, timestamp)
    user = User.find(user_id)
    user.last_interaction_at = Time.at(timestamp).to_datetime
    user.save
  end

end