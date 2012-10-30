require_relative 'pavlov'

class SendMailForActivityInteractor
  include Pavlov::Interactor

  arguments :activity

  def execute
    users = query :users_by_graph_user_ids, filter.add_to(@activity)

    users.each do |user|
     command :send_activity_mail_to_user, user, @activity
    end
  end

  def filter
    Activity::Listener.all[{class:"GraphUser", list: :notifications}]
  end

  def authorized?
    @options[:current_user]
  end
end
