class Site < OurOhm
  attribute :url
  index :url

  set :facts, Fact
  
  def fact_count
    return self.facts.count
  end
end