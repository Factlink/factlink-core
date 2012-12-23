require_relative 'channel/generated_channel'
require_relative 'channel/created_facts'
require_relative 'channel/user_stream'
require_relative 'channel/overtaker'
require_relative 'channel/activities'

class Channel < OurOhm
  include Activity::Subject

  def type; "channel" end

  attribute :title
  index :title

  timestamped_set :activities, Activity
  timestamped_set :added_facts, Activity

  attribute :lowercase_title

  attribute :slug_title
  index :slug_title

  after :create, :increment_mixpanel_count
  def increment_mixpanel_count
    if type == 'channel' and self.created_by.user
      mixpanel = FactlinkUI::Application.config.mixpanel.new({}, true)

      mixpanel.increment_person_event self.created_by.user.id.to_s, channels_created: 1
    end
  end

  alias :old_set_title :title= unless method_defined?(:old_set_title)
  def title=(new_title)
    old_set_title new_title
    self.lowercase_title = new_title.downcase
    self.slug_title = new_title.to_url
  end

  before :save, :before_save_actions
  def before_save_actions
    self.title = self.title
  end

  after :save, :after_save_actions
  def after_save_actions
    if type == 'channel'
      t = Topic.for_channel(self)
      t.reposition_in_top
      self.created_by.channels_by_authority.add(self)
    end
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

  def mark_as_read
    unread_facts.make_empty
  end

  alias :old_real_delete :delete unless method_defined?(:old_real_delete)
  def real_delete
    contained_channels.each do |subch|
      subch.containing_channels.delete self
    end
    containing_channels.each do |ch|
      ch.contained_channels.delete self
    end
    Activity.for(self).each do |a|
      a.delete
    end
    created_by.channels_by_authority.delete(self)
    old_real_delete
  end

  def delete
    real_delete
  end

  def add_created_channel_activity
    Activities.new(self).add_created
  end

  def unread_count
    unread_facts.size
  end

  def facts(opts={})
    return [] if new?

    facts_opts = {reversed:true}
    facts_opts[:withscores] = opts[:withscores] ? true : false
    facts_opts[:count] = opts[:count].to_i if opts[:count]

    limit = opts[:from] || 'inf'

    res = sorted_cached_facts.below(limit,facts_opts)

    fixchan = false

    res.delete_if do |item|
      check_item = facts_opts[:withscores] ? item[:item] : item
      invalid = Fact.invalid(check_item)
      fixchan |= invalid
      invalid
    end

    if fixchan
      Resque.enqueue(CleanChannel, self.id)
    end

    res
  end

  def validate
    execute_callback(:before, :validate) # needed because of ugly ohm contrib callbacks
    super
    assert_present :title
    assert_present :slug_title
    assert_present :created_by
    assert_unique([:slug_title,:created_by_id])
    execute_callback(:after, :validate) # needed because of ugly ohm contrib callbacks
  end

  def remove_fact(fact)
    self.sorted_internal_facts.delete(fact) if self.sorted_internal_facts.include?(fact)
    self.sorted_delete_facts.add(fact)
    Resque.enqueue(RemoveFactFromChannel, fact.id, self.id)
    activity(self.created_by,:removed,fact,:from,self)
  end

  def to_s
    self.title
  end

  def include?(obj)
    self.sorted_cached_facts.include?(obj)
  end

  def is_real_channel?
    true
  end
  # DEPRECATED -- use is_real_channel?
  def editable?; is_real_channel?; end
  def inspectable?; is_real_channel?; end
  def has_authority?; is_real_channel?; end
  def can_be_added_as_subchannel?; is_real_channel?; end
  # /DEPRECATED

  def to_hash
    return {:id => id,
            :title => title,
            :created_by => created_by}
  end

  def add_channel(channel)
    if (! contained_channels.include?(channel)) && channel.can_be_added_as_subchannel?
      add_created_channel_activity
      contained_channels << channel
      channel.containing_channels << self
      Resque.enqueue(AddChannelToChannel, channel.id, self.id)
      activity(self.created_by,:added_subchannel,channel,:to,self)
    end
  end

  def remove_channel(channel)
    if (contained_channels.include?(channel))
      contained_channels.delete(channel)
      channel.containing_channels.delete(self)
      Resque.enqueue(RemoveChannelFromChannel, channel.id, self.id)
      activity(self.created_by, :removed, channel, :to, self)
    end
  end

  def containing_channels_for(user)
    ChannelList.new(user).channels & containing_channels
  end

  def topic
    Topic.for_channel self
  end

  def valid_for_activity?
    sorted_cached_facts.size > 0
  end

  def self.for_fact(f)
    f.channels.all
  end
end
