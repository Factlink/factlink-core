class Site
  include Mongoid::Document
  field :url

  # references_many :factlink_tops, :stored_as => :array, :inverse_of => :sites    
  has_many :factlink_tops
  
  validates_presence_of :url
end