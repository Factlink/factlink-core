class MigrateRemoveOldActivitiesForUserWorker
  @queue = :aaa_migration

  def self.perform user_id
    graph_user = User.find(user_id).graph_user

    graph_user.notifications.each do |a|
      unless %w(created_fact_relation created_comment created_sub_comment
        created_conversation replied_message followed_user).include?(a.action)
        a.remove_from_list graph_user.notifications
      end
    end

    graph_user.stream_activities.each do |a|
      unless %w(created_fact_relation created_comment created_sub_comment
        added_fact_to_channel believes doubts disbelieves followed_user).include?(a.action)
        a.remove_from_list graph_user.stream_activities
      end
    end
  end
end
