require 'pavlov'

module Interactors
  class SendMailForActivity
    include Pavlov::Interactor

    arguments :activity

    def execute
      recipients.each do |user|
        command :send_activity_mail_to_user, user.id, @activity.id
      end
    end

    def recipients
      users_by_graph_user_ids.keep_if { |user| user.receives_mailed_notifications }
    end

    def users_by_graph_user_ids
      graph_user_ids = query :object_ids_by_activity, @activity, "GraphUser", :notifications
      return query :users_by_graph_user_ids, graph_user_ids
    end

    def authorized?
      @options[:current_user]
    end
  end
end
