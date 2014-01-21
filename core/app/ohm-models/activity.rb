require 'pavlov'

class GraphUser < OurOhm;end # needed because of removed const_missing from ohm

require_relative 'activity/followers'
require_relative 'activity/listener'
require_relative 'activity/create_listeners'
require_relative '../interactors/interactors/send_mail_for_activity'

class Activity < OurOhm
  reference :user, GraphUser

  attribute :created_at
  attribute :updated_at

  generic_reference :subject
  generic_reference :object

  attribute :action
  index     :action

  def self.valid_actions_in_notifications
    %w(created_comment created_sub_comment followed_user)
  end

  def self.valid_actions_in_stream_activities
     %w(created_comment created_sub_comment followed_user
        believes doubts disbelieves)
  end

  def self.valid_actions
    (valid_actions_in_notifications + valid_actions_in_stream_activities).uniq
  end

  def validate
    assert self.class.valid_actions.include?(action.to_s), "invalid action: #{action.to_s}"
  end

  alias :old_set_user :user= unless method_defined?(:old_set_user)
  def user=(new_user)
    old_set_user new_user.graph_user
  end

  def create
    self.created_at ||= Time.now.utc.to_s

    result = super

    Resque.enqueue(ProcessActivity, id)
    Pavlov.interactor(:'send_mail_for_activity', activity: self, pavlov_options: { current_user: true })

    result
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


  # OBSOLETE
  # Please don't use this method in new stuff
  # only tests still uses this
  def self.for(search_for)
    res = find(subject_id: search_for.id, subject_class: search_for.class) |
          find(object_id: search_for.id, object_class: search_for.class)

    res |= find(user_id: search_for.id) if search_for.class == GraphUser

    res
  end

  def to_hash_without_time
    h = { user: user,
          action: action.to_sym,
          subject: subject }
    h[:object] = object if object
    h
  end

  # WARNING: if this method returns false, we assume it will never become
  #          valid again either, and remove/destroy freely.
  def still_valid?
    valid? and user_still_valid? and subject_still_valid? and object_still_valid?
  end

  def timestamp
    Ohm::Model::TimestampedSet.current_time(DateTime.parse(created_at))
  end

  def add_to_list_with_score list
    list.add(self,timestamp)
    containing_sorted_sets.sadd list.key.to_s
  end

  def remove_from_list list
    list.delete self
    containing_sorted_sets.srem list.key.to_s
  end

  protected

  def write
    self.updated_at = Time.now.utc.to_s

    super
  end

  private

  def containing_sorted_sets
    key[:containing_sorted_sets]
  end

  def user_still_valid?
    return true if not user_id

    user and user.user and not user.user.deleted
  end

  def subject_still_valid?
    return true unless subject_id

    Kernel.const_defined?(subject_class) and subject
  end

  def object_still_valid?
    return true unless object_id

    Kernel.const_defined?(object_class) and object
  end
end

Activity::ListenerCreator.new.create_activity_listeners
