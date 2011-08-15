class Channel < OurOhm
  
  attribute :title
  attribute :description
  
  set :contained_channels, Channel
  
  set :internal_facts, Fact
  set :delete_facts, Fact
  
  index :title
  
  def facts
    fs = internal_facts
    contained_channels.each do |ch|
      fs |= ch.facts
    end
    fs - delete_facts
  end
  
  reference :created_by, GraphUser
  
  def validate
    assert_present :title
    assert_present :created_by
  end
  
  def add_fact(fact)
    self.internal_facts.add(fact)
  end
  
  def remove_fact(fact)
    if self.internal_facts.include?(fact)
      self.internal_facts.delete(fact)
    else
      self.delete_facts.add(fact)
    end
  end
  
  def to_s
    self.id
  end
  
  def fork(user)
    c = Channel.create(:created_by => user, :title => title, :description => description)
    c.add_channel(self)
    c
  end
  
  def add_channel(channel)
    contained_channels << channel
  end
  
end