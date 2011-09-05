module UserProxy

  deprecate
  def username
    user.username
  end

  deprecate
  def username=(value)
    user.username=value
  end
  
  deprecate
  def graph_user
    return self
  end
end

class GraphUser < OurOhm
  include UserProxy
  
  reference :user, lambda { |id| User.find(id) }

  set :beliefs_facts, Basefact
  set :doubts_facts, Basefact
  set :disbeliefs_facts, Basefact

  collection :created_facts, Basefact, :created_by
  
  define_memoized_method :channels, do
    Channel.find(:created_by_id => self.id).except(:discontinued => 'true')
  end
   
  collection :activities, Activity, :user
  attribute :cached_authority
  
  def calculate_authority
    self.cached_authority = 1.0 + Math.log2(self.real_created_facts.inject(1) { |result, element| result * element.influencing_authority})
    self.class.key[:top_users].zadd(self.cached_authority, id)
    self.save
  end
  
  def remove_from_top_users
    self.class.key[:top_users].zrem(id)
  end
  after :delete, :remove_from_top_users

  def self.top(nr=10)
    self.key[:top_users].zrevrange(0,nr-1).map(&GraphUser)
  end
  
  def authority
    self.cached_authority || 1.0
  end

  def rounded_authority
    sprintf('%.1f',self.authority)
  end

  # user.facts_he(:beliefs)
  def facts_he(type)
    self.send("#{type}_facts")
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
    beliefs_facts.all + doubts_facts.all + disbeliefs_facts.all
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
    [:beliefs, :doubts, :disbeliefs].each do |type|
      facts_he(type).delete(fact)
    end
  end
  
  
end