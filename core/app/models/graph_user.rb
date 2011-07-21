require File.expand_path("../fact.rb", __FILE__)

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

  # Authority of the user
  def authority
    1.0
  end
  
  set :beliefs_facts, Fact
  set :doubts_facts, Fact
  set :disbeliefs_facts, Fact
  #user.facts_he(:beliefs)
  def facts_he(type)
    self.send("#{type}_facts")
  end


  def facts
    beliefs_facts.all + doubts_facts.all + disbeliefs_facts.all
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

  def has_opinion?(type, fact)
    facts_he(type).include?(fact)
  end
  
end