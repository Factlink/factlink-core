require 'singleton'

class GlobalFeed
  include Singleton

  def initialize
    @key = Nest.new(:global_feed)
  end

  def self.[](ignored_id)
    return instance
  end

  def all_activities
    key = @key[:all_activities]
    Ohm::Model::TimestampedSet.new(key, Ohm::Model::Wrapper.wrap(Activity))
  end
end
