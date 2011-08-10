class Channel < OurOhm
  
  attribute :title
  attribute :description
  
  set :facts, Fact
  
  reference :created_by, GraphUser
  
  def validate
    assert_present :title
    # assert_present :user # User always needed?
  end
  
  def add_fact(fact)
    self.facts.add(fact)
  end
  
  def remove_fact(fact)
    self.facts.delete(fact)
  end
  
  def to_s
    self.id
  end
end