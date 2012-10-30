require 'ohm/contrib'

require_relative 'activity/subject'
require_relative 'activity/listener'
require_relative 'activity/create_listeners'
require_relative '../interactors/pavlov'
require_relative '../interactors/send_mail_for_activity_interactor'

class Activity < OurOhm
  include Ohm::Timestamping
  reference :user, GraphUser

  include Pavlov::Helpers

  alias :old_set_user :user= unless method_defined?(:old_set_user)
  def user=(new_user)
    old_set_user new_user.graph_user
  end

  after :create, :process_activity
  def process_activity
    Resque.enqueue(ProcessActivity, self.id)
  end


  generic_reference :subject
  generic_reference :object

  attribute :action
  index     :action

  def self.for(search_for)
    res = find(subject_id: search_for.id, subject_class: search_for.class) | find(object_id: search_for.id, object_class: search_for.class)
    if search_for.class == GraphUser
      res |= find(user_id: search_for.id)
    end
    res
  end

  def to_hash_without_time
    h = { user: user,
          action: action.to_sym,
          subject: subject, }
    h[:object] = object if object
    h
  end

  def still_valid?
    (user or not user_id) and
      (subject or not subject_id) and
      (object or not object_id)
  end

  def valid_for_show?
    still_valid? and
    ((not object.respond_to?(:valid_for_activity?))  or object.valid_for_activity?) and
    ((not subject.respond_to?(:valid_for_activity?)) or subject.valid_for_activity?)
  end

  def timestamp
    Ohm::Model::TimestampedSet.current_time(DateTime.parse(created_at))
  end

  def add_to_list_with_score list
    list.add(self,timestamp)
    self.key[:containing_sorted_sets].sadd list.key.to_s
  end

  def remove_from_list list
    list.delete self
    self.key[:containing_sorted_sets].srem list.key.to_s
  end

  before :delete, :remove_from_containing_sorted_sets

  def remove_from_containing_sorted_sets
    self.key[:containing_sorted_sets].smembers.each do |list|
      Nest.new(list).zrem self.id
    end
    self.key[:containing_sorted_sets].del
  end

  def after_create
    interactor :send_mail_for_activity, self, current_user: user
  end

end

