module Interactors
  class SendMailForActivity
    include Pavlov::Interactor

    arguments :activity

    def execute
      recipients.each do |user|
        Resque.enqueue SendActivityMailToUser, user.id, activity.id
      end
    end

    def recipients
      graph_user_ids = query(:'object_ids_by_activity',
                                 activity: activity, class_name: "GraphUser",
                                 list: :notifications)

      query :'users/filter_mail_subscribers',
        graph_user_ids: graph_user_ids, type: 'mailed_notifications'
    end

    def authorized?
      pavlov_options[:current_user]
    end
  end
end
