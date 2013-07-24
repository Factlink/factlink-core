require 'ohm/contrib'
require 'pavlov'

class GraphUser < OurOhm;end # needed because of removed const_missing from ohm

require_relative 'activity/subject'
require_relative 'activity/followers'
require_relative 'activity/listener'
require_relative 'activity/create_listeners'
require_relative '../interactors/interactors/send_mail_for_activity'

class Activity < OurOhm
  include Ohm::Timestamping
  reference :user, GraphUser

  generic_reference :subject
  generic_reference :object

  attribute :action
  index     :action

  alias :old_set_user :user= unless method_defined?(:old_set_user)
  def user=(new_user)
    old_set_user new_user.graph_user
  end

  after :create, :process_activity
  def process_activity
    Resque.enqueue(ProcessActivity, id)
  end

  after :create, :send_mail_for_activity
  def send_mail_for_activity
    Pavlov.old_interactor :send_mail_for_activity,
                        self, {current_user: true}
  end

  before :delete, :remove_from_containing_sorted_sets
  def remove_from_containing_sorted_sets
    containing_sorted_sets.smembers.each do |list|
      Nest.new(list).zrem id
    end
    containing_sorted_sets.del
  end


  # OBSOLETE
  # Please don't use this method in new stuff
  # only channel.rb and tests still uses this
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

  def still_valid?
    user_valid? and subject_valid? and object_valid?
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

  private

  def containing_sorted_sets
    key[:containing_sorted_sets]
  end

  def user_valid?
    user or not user_id
  end

  def subject_valid?
    subject or not subject_id
  end

  def object_valid?
    object or not object_id
  end
end

