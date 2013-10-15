module Interactors
  class SendMailForActivity
    include Pavlov::Interactor

    arguments :activity

    def execute
      recipients.each do |user|
        Resque.enqueue Commands::SendActivityMailToUser,
          user_id: user.id, activity_id: activity.id, pavlov_options: pavlov_options
      end
    end

    def recipients
      users.select do |user|
        user.user_notification.can_receive?('mailed_notifications')
      end
    end

    def users
      graph_user_ids = query(:'object_ids_by_activity',
                                 activity: activity, class_name: "GraphUser",
                                 list: :notifications)

      graph_user_ids.map do |graph_user_id|
        GraphUser[graph_user_id].user
      end
    end

    def authorized?
      pavlov_options[:current_user]
    end
  end
end
