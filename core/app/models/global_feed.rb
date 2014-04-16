require 'singleton'

class GlobalFeed
  include Singleton

  def initialize
    @key = Nest.new(:global_feed)
  end

  def self.[](ignored_id)
    # to support listeners created in create_listeners this class must behave as if it were a
    # non-singleton because Listener.process always looks up the instance by "id"
    instance
  end

  def all_activities
    key = @key[:all_activities]
    Ohm::Model::TimestampedSet.new(key, Ohm::Model::Wrapper.wrap(Activity))
  end

  def all_discussions
    key = @key[:all_discussions]
    Ohm::Model::TimestampedSet.new(key, Ohm::Model::Wrapper.wrap(Activity))
  end

end
