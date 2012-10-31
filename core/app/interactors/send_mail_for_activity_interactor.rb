require_relative 'pavlov'

class SendMailForActivityInteractor
  include Pavlov::Interactor

  arguments :activity

  def execute
    graph_user_ids = query :object_ids_by_activity, @activity, "GraphUser", :notifications
    users = query :users_by_graph_user_ids, graph_user_ids

    users.each do |user|
      if user.receives_mailed_notifications
        command :send_activity_mail_to_user, user, @activity
      end
    end
  end

  def authorized?
    @options[:current_user]
  end
end
