class SendActivityMailToUser
  include SuckerPunch::Job

  def perform(user_id, activity_id)
    ActiveRecord::Base.connection_pool.with_connection do
      ActivityMailer.new_activity(user_id, activity_id).deliver
    end
  end
end
