require 'pavlov'

module Interactors
  class SendMailForActivity
    include Pavlov::Interactor

    arguments :activity

    def execute
      recipients.each do |user|
        Resque.enqueue Commands::SendActivityMailToUser, user.id, @activity.id, pavlov_options
      end
    end

    def recipients
      users_by_graph_user_ids.select { |user| user.receives_mailed_notifications }
    end

    def users_by_graph_user_ids
      graph_user_ids = old_query :object_ids_by_activity, @activity, "GraphUser", :notifications
      return old_query :users_by_graph_user_ids, graph_user_ids
    end

    def authorized?
      pavlov_options[:current_user]
    end
  end
end
