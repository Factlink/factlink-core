class Site
  include Mongoid::Document
  field :url

  has_many :facts
  
  validates_uniqueness_of :url
  
  def fact_count
    return self.facts.count
  end
end