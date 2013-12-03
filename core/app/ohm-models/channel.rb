require_relative 'channel/activities'

class Channel < OurOhm
  include Activity::Subject

  attribute :title
  index :title

  attribute :lowercase_title

  attribute :slug_title
  index :slug_title

  def create
    result = super

    Topic.get_or_create_by_channel(self)

    result
  end

  alias :old_set_title :title= unless method_defined?(:old_set_title)
  def title=(new_title)
    old_set_title new_title
    self.lowercase_title = new_title.downcase
    self.slug_title = new_title.to_url
  end

  def save
    self.title = self.title
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
    title
  end

  def topic
    Topic.get_or_create_by_channel self
  end
end
