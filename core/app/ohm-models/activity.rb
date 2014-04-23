require_relative 'activity/listener'
require_relative 'activity/create_listeners'

class Activity < OurOhm
  attribute :user_id
  index :user_id

  attribute :created_at

  generic_reference :subject

  attribute :action
  index     :action

  def self.valid_actions_in_notifications
    %w(created_comment created_sub_comment followed_user)
  end

  def self.valid_actions_in_stream_activities
     %w(created_comment created_sub_comment followed_user)
  end

  def self.valid_actions
    (valid_actions_in_notifications + valid_actions_in_stream_activities).uniq
  end

  def validate
    assert self.class.valid_actions.include?(action.to_s), "invalid action: #{action.to_s}"
  end

  def user=(new_user)
    self.user_id = new_user.id.to_s
  end

  def user
    User.where(id: user_id).first
  end

  def delete
    remove_from_containing_sorted_sets
    super
  end

  def remove_from_containing_sorted_sets
    containing_sorted_sets.smembers.each do |list|
      Nest.new(list).zrem id
    end
    containing_sorted_sets.del
  end

  # WARNING: if this method returns false, we assume it will never become
  #          valid again either, and remove/destroy freely.
  def still_valid?
    valid? and user_still_valid? and subject_still_valid?
  end

  def timestamp
    TimestampedSet.current_time(DateTime.parse(created_at))
  end

  def add_to_list_with_score list
    list.add(self,timestamp)
    containing_sorted_sets.sadd list.key.to_s
  end

  def remove_from_list list
    list.delete self
    containing_sorted_sets.srem list.key.to_s
  end

  private

  def containing_sorted_sets
    key[:containing_sorted_sets]
  end

  def user_still_valid?
    return true if not user_id
    return false unless user

    real_user = User.where(id: user.id).first

    real_user && !real_user.deleted
  end

  def subject_still_valid?
    return true unless subject_id

    Kernel.const_defined?(subject_class) and subject
  end
end

Activity::ListenerCreator.new.create_activity_listeners
