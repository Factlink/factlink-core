require_relative 'channel/generated_channel'
require_relative 'channel/created_facts'
require_relative 'channel/user_stream'
require_relative 'channel/overtaker'

class Channel < OurOhm
  include Activity::Subject

  def type; "channel" end

  attribute :title
  index :title

  attribute :lowercase_title
  alias :old_set_title :title= unless method_defined?(:old_set_title)
  def title=(new_title)
    old_set_title new_title
    self.lowercase_title = new_title.downcase
  end


  reference :created_by, GraphUser
  alias :graph_user :created_by
  index :created_by_id

  set :contained_channels, Channel
  set :containing_channels, Channel

  timestamped_set :sorted_internal_facts, Fact
  timestamped_set :sorted_delete_facts, Fact
  timestamped_set :sorted_cached_facts, Fact

  after :create, :update_top_users

  delegate :unread_count, :mark_as_read, :to => :sorted_cached_facts

  attribute :discontinued
  index :discontinued
  alias :old_real_delete :delete unless method_defined?(:old_real_delete)
  def real_delete
    contained_channels.each do |subch|
      subch.containing_channels.delete self
    end
    Activity.for(self).each do |a|
      a.delete
    end
    old_real_delete
    update_top_users
  end

  def delete
    self.discontinued = true
    save
    update_top_users
  end

  def update_top_users
    self.created_by.andand.reposition_in_top_users
  end


  def facts(opts={})
    return [] if new?

    facts_opts = {reversed:true}
    facts_opts[:withscores] = opts[:withscores] ? true : false
    facts_opts[:count] = opts[:count].to_i if opts[:count]

    limit = opts[:from] || 'inf'

    res = sorted_cached_facts.below(limit,facts_opts)

    if facts_opts[:withscores]
     res = res.delete_if{ |f| Fact.invalid(f[:item]) }
    else
     res = res.delete_if{ |f| Fact.invalid(f) }
    end

    res
  end

  def validate
    execute_callback(:before, :validate) # needed because of ugly ohm contrib callbacks
    super
    assert_present :title
    assert_present :created_by
    assert_unique([:title,:created_by_id])
    execute_callback(:after, :validate) # needed because of ugly ohm contrib callbacks
  end

  def add_fact(fact)
    self.sorted_delete_facts.delete(fact)
    self.sorted_internal_facts.add(fact)
    Resque.enqueue(AddFactToChannel, fact.id, self.id)
    activity(self.created_by,:added,fact,:to,self)
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

  def editable?
    true
  end

  def inspectable?
    true
  end


  def related_users(calculator=RelatedUsersCalculator.new,options)
    options[:without] ||= []
    options[:without] << created_by
    calculator.related_users(facts,options)
  end

  def to_hash
    return {:id => id,
            :title => title,
            :created_by => created_by,
            :discontinued => discontinued}
  end

  def add_channel(channel)
    if (! contained_channels.include?(channel))
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
    Channel.active_channels_for(user) & containing_channels
  end

  def self.active_channels_for(user)
    Channel.find(:created_by_id => user.id).except(:discontinued => 'true')
  end

  def self.for_fact(f)
    Channel.all.all.keep_if {|ch| ch.include?(f) && ch.type == 'channel'}
  end

  protected
    def self.recalculate_all
      puts "WARNING: Channel.recalculate_all should not be used anymore, since it does nothing"
    end

end
