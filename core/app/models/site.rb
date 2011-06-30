class Site
  include Mongoid::Document
  field :url

  has_many :factlinks
  
  validates_uniqueness_of :url
  
  def factlink_count
    return self.factlinks.count
  end
end