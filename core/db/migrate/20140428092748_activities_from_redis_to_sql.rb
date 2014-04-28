class ActivitiesFromRedisToSql < ActiveRecord::Migration
  def up
    Nest.new('Activity:all').smembers.each do |id|
      activity_key = Nest.new('Activity')[id]

      activity = Activity.new
      activity.user_id = activity_key.hget('user_id')
      activity.action = activity_key.hget('action')
      activity.subject_type = activity_key.hget('subject_class')
      activity.subject_id = activity_key.hget('subject_id')
      activity.created_at = Time.parse(activity_key.hget('created_at'))
      activity.updated_at = Time.parse(activity_key.hget('created_at'))
      activity.save!
    end
  end

  def down
  end
end
