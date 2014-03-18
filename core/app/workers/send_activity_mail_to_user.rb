class SendActivityMailToUser
  @queue = :nnn_mail

  def self.perform(user_id, activity_id)
    ActivityMailer.new_activity(user_id, activity_id).deliver
  end
end
