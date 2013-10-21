require_relative 'channel/activities'

class Channel < OurOhm
  include Activity::Subject

  def type
    'channel'
  end

  attribute :title
  index :title

  attribute :lowercase_title

  attribute :slug_title
  index :slug_title

  def create
    result = super

    increment_mixpanel_count
    Topic.get_or_create_by_channel(self) if type == 'channel'

    result
  end

  def increment_mixpanel_count
    return unless type == 'channel' and self.created_by.user

    mixpanel = FactlinkUI::Application.config.mixpanel.new({}, true)
    mixpanel.increment_person_event self.created_by.user.id.to_s, channels_created: 1
  end

  alias :old_set_title :title= unless method_defined?(:old_set_title)
  def title=(new_title)
    old_set_title new_title
    self.lowercase_title = new_title.downcase
    self.slug_title = new_title.to_url
  end

  def save
    self.title = self.title if type == 'channel'
    super
  end

  reference :created_by, GraphUser
  alias :graph_user :created_by
  index :created_by_id

  set :contained_channels, Channel
  set :containing_channels, Channel

  set :unread_facts, Channel

  timestamped_set :sorted_internal_facts, Fact
  timestamped_set :sorted_delete_facts, Fact
  timestamped_set :sorted_cached_facts, Fact

  def delete
    contained_channels.each do |subch|
      subch.containing_channels.delete self
    end
    containing_channels.each do |ch|
      ch.contained_channels.delete self
    end
    Activity.for(self).each do |a|
      a.delete
    end
    super
  end

  def channel_facts
    ChannelFacts.new(self)
  end
  private :channel_facts
  delegate :mark_as_read, :facts, :remove_fact, :include?,
           :to => :channel_facts

  def validate
    result = super

    assert_present :title
    assert_present :slug_title
    assert_present :created_by
    assert_unique([:slug_title,:created_by_id])

    result
  end

  def to_s
    self.title
  end

  def is_real_channel?
    true
  end

  def add_channel(channel)
    return false if contained_channels.include?(channel)
    return false unless channel.is_real_channel?

    contained_channels << channel
    channel.containing_channels << self
    true
  end

  def remove_channel(channel)
    return false unless contained_channels.include?(channel)

    contained_channels.delete(channel)
    channel.containing_channels.delete(self)
    true
  end

  def containing_channels_for_ids(user)
    ChannelList.new(user).containing_channel_ids_for_channel self
  end

  def topic
    Topic.get_or_create_by_channel self
  end
end
