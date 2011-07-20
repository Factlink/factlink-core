class Site < OurOhm
  attribute :url
  index :url

  set :facts, Fact
  
  #validates_uniqueness_of :url
  
  def fact_count
    return self.facts.count
  end
end