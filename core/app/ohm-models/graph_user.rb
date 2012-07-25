class GraphUser < OurOhm
  include Activity::Subject

  def graph_user
    return self
  end

  reference :user, lambda { |id| id && User.find(id) }

  timestamped_set :notifications, Activity
  timestamped_set :stream_activities, Activity

  set :believes_facts, Basefact
  set :doubts_facts, Basefact
  set :disbelieves_facts, Basefact
  private :believes_facts, :doubts_facts, :disbelieves_facts

  collection :created_facts, Basefact, :created_by

  sorted_set :channels_by_authority, Channel do |ch|
    if ch.topic # TODO: why is this ever nil? check this!
      Authority.from(ch.topic, for: ch.created_by)
    else
      0.0
    end
  end

  define_memoized_method :internal_channels do
    Channel.active_channels_for(self)
  end

  def channel_manager
    @channel_manager || ChannelManager.new(self)
  end

  delegate :editable_channels_for, :editable_channels, :editable_channels_by_authority, :containing_channel_ids,
         :to => :channel_manager


  define_memoized_method :channels do
    channels = self.internal_channels.sort_by(:lowercase_title, order: 'ALPHA ASC').to_a

    channels.delete(self.created_facts_channel)
    channels.unshift(self.created_facts_channel)

    channels.delete(self.stream)
    channels.unshift(self.stream )

    channels
  end

  reference :stream, Channel::UserStream
  def create_stream
    self.stream = Channel::UserStream.create(:created_by => self)
    save
  end
  after :create, :create_stream

  reference :created_facts_channel, Channel::CreatedFacts
  def create_created_facts_channel
    self.created_facts_channel = Channel::CreatedFacts.create(:created_by => self)
    save
  end
  after :create, :create_created_facts_channel

  attribute :interestingness

  after :create, :reposition_in_top_users
  def reposition_in_top_users
    self.interestingness = self.internal_channels.size
    GraphUser.key[:top_users].zadd(self.interestingness, id)
  end

  def remove_from_top_users
    GraphUser.key[:top_users].zrem(id)
  end
  after :delete, :remove_from_top_users

  def self.top(nr = 10)
    GraphUser.key[:top_users].zrevrange(0,nr-1).map(&GraphUser)
  end

  # user.facts_he(:believes)
  def facts_he(type)
    send(:"#{Opinion.real_for(type)}_facts")
  end

  def has_opinion?(type, fact)
    facts_he(type).include?(fact)
  end

  def opinion_on(fact)
    Opinion.types.each do |opinion|
      return opinion if has_opinion?(opinion,fact)
    end
    return nil
  end

  def facts
    facts_he(:believes) | facts_he(:doubts) | facts_he(:disbelieves)
  end

  def real_created_facts
    created_facts.find_all { |fact| fact.class == Fact }
  end
  alias :really_realy_created_facts :real_created_facts

  def update_opinion(type, fact)
    remove_opinions(fact)
    facts_he(type) << fact
  end

  def remove_opinions(fact)
    Opinion.types.each do |type|
      facts_he(type).delete(fact)
    end
  end


end
