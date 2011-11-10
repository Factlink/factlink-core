class GraphUser < OurOhm
  def graph_user
    return self
  end

  reference :user, lambda { |id| id && User.find(id) }

  set :believes_facts, Basefact
  set :doubts_facts, Basefact
  set :disbelieves_facts, Basefact
  private :believes_facts, :doubts_facts, :disbelieves_facts

  collection :created_facts, Basefact, :created_by

  define_memoized_method :internal_channels do
    Channel.find(:created_by_id => self.id).except(:discontinued => 'true').sort
  end

  def channel_manager
    @channel_manager || ChannelManager.new(self)
  end
  delegate :editable_channels_for, 
         :to => :channel_manager

  
  define_memoized_method :channels do
    channels = self.internal_channels.to_a

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


  collection :activities, Activity, :user
  
  
  after :create, :calculate_authority
  
  attribute :cached_authority
  index :cached_authority
  def calculate_authority
    self.cached_authority = 1.0 + Math.log2(self.real_created_facts.inject(1) { |result, fact| result * fact.influencing_authority})
    self.class.key[:top_users].zadd(self.cached_authority, id)
    self.save
  end

  def remove_from_top_users
    self.class.key[:top_users].zrem(id)
  end
  after :delete, :remove_from_top_users

  def self.top(nr = 10)
    self.key[:top_users].zrevrange(0,nr-1).map(&GraphUser)
  end

  def authority
    self.cached_authority || 1.0
  end

  def rounded_authority
    auth = [self.authority.to_f, 1.0].max
    sprintf('%.1f', auth)
  end

  # user.facts_he(:beliefs)
  def facts_he(type)
    type = type.to_sym
    belief_check(type)
    if [:beliefs,:believes].include?(type)
      believes_facts
    elsif [:doubts].include?(type)
      doubts_facts
    elsif [:disbeliefs,:disbelieves].include?(type)
      disbelieves_facts
    else
      raise "invalid opinion"
    end
  end

  def has_opinion?(type, fact)
    facts_he(type).include?(fact)
  end

  def opinion_on(fact)
    [:beliefs, :doubts, :disbeliefs].each do |opinion|
      return opinion if self.has_opinion?(opinion,fact)  
    end
    return nil
  end

  def facts
    facts_he(:believes) | facts_he(:doubts) | facts_he(:disbelieves)
  end

  def real_facts
    facts.find_all { |fact| fact.class == Fact }
  end

  def real_created_facts
    created_facts.find_all { |fact| fact.class == Fact }
  end

  def update_opinion(type, fact)
    # Remove existing opinion by user
    remove_opinions(fact)
    facts_he(type) << fact
  end

  def remove_opinions(fact)
    [:believes, :doubts, :disbelieves].each do |type|
      facts_he(type).delete(fact)
    end
  end


end
