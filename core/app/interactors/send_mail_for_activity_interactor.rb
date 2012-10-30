require_relative 'pavlov'

class SendMailForActivityInteractor
  include Pavlov::Interactor

  arguments :activity

  def execute
    graph_users = query :users_by_ids, filter.add_to(@activity)

    graph_users.each do |graph_user|
     command :send_activity_mail_to_user, @activity, graph_user
    end
  end

  def filter
    Activity::Listener.all[{class:"GraphUser", list: :notifications}]
  end

  def authorized?
    true
  end
end
