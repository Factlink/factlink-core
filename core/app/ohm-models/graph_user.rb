autoload :Basefact, 'basefact'
autoload :Fact, 'fact'
autoload :FactRelation, 'fact_relation'
autoload :GraphUser, 'graph_user'
autoload :OurOhm, 'our_ohm'
autoload :Site, 'site'

autoload :Opinion, 'opinion'
autoload :Opinionable, 'opinionable'
#require File.join(File.dirname(__FILE__), *%w[basefact.rb])

module UserProxy

  deprecate
  def username
    user.username
  end

  deprecate
  def username=(value)
    user.username=value
  end
end

class GraphUser < OurOhm
  include UserProxy
  
  reference :user, lambda { |id| User.find(id) }

  set :beliefs_facts, Basefact
  set :doubts_facts, Basefact
  set :disbeliefs_facts, Basefact

  def to_s
    username
  end

  # Authority of the user
  def authority
    1.0
  end

  # user.facts_he(:beliefs)
  def facts_he(type)
    self.send("#{type}_facts")
  end

  def has_opinion?(type, fact)
    facts_he(type).include?(fact)
  end

  def facts
    beliefs_facts.all + doubts_facts.all + disbeliefs_facts.all
  end
  
  def real_facts
    facts.find_all { |fact| fact.class == Fact }
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