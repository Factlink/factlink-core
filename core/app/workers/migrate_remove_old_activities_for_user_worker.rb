class MigrateRemoveOldActivitiesForUserWorker
  @queue = :aaa_migration

  def self.perform user_id
    graph_user = User.find(user_id).graph_user

    graph_user.notifications.each do |a|
      unless Activity.valid_actions_in_notifications.include?(a.action)
        a.remove_from_list graph_user.notifications
      end
    end

    graph_user.stream_activities.each do |a|
      unless Activity.valid_actions_in_stream_activities.include?(a.action)
        a.remove_from_list graph_user.stream_activities
      end
    end
  end
end
