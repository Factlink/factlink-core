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

  def channel_manager
    @channel_manager || ChannelManager.new(self)
  end

  delegate :editable_channels_for, :editable_channels, :containing_channel_ids,
         :to => :channel_manager


  define_memoized_method :channels do
    channels = ChannelList.new(self).sorted_real_channels_as_array

    channels.unshift(self.created_facts_channel)
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


  # TODO REMOVE AND MIGRATE AWAY
  # Those were the suggested users (before suggested channels)
  # They aren't used anymore
  after :create, :reposition_in_top_users
  def reposition_in_top_users
    self.interestingness = ChannelList.new(self).channels.size
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
  # DEPRECATED: Doesn't work anymore:
  def facts_he(type)
    send(:"#{Opinion.real_for(type)}_facts")
  end

  def has_opinion?(type, fact)
    fact.opiniated(type).include? self
  end

  def opinion_on(fact)
    Opinion.types.each do |opinion|
      return opinion if has_opinion?(opinion,fact)
    end
    return nil
  end

  def real_created_facts
    created_facts.find_all { |fact| fact.class == Fact }
  end
  alias :really_realy_created_facts :real_created_facts

  def update_opinion(type, fact)
    facts_he(type) << fact
  end

end
