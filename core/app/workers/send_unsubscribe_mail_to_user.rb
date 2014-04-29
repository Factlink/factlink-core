class SendUnsubscribeMailToUser
  include SuckerPunch::Job

  def perform(user_id, type)
    ActiveRecord::Base.connection_pool.with_connection do
      SubscriptionsMailer.unsubscribe(user_id, type).deliver
    end
  end
end
