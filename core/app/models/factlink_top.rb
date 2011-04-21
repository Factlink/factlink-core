class FactlinkTop
  include Mongoid::Document
  include Mongoid::Timestamps

  field :displaystring

  # references_many :sites, :stored_as => :array, :inverse_of => :factlink_tops
  # references_many :factlink_subs, :type => Array, :default => []
  
  belongs_to :site
  has_many :factlink_subs
  
  validates_presence_of :displaystring
  
  def to_s
    displaystring
  end
  
  # Create search index on :displaystring
  include Sunspot::Mongoid
  searchable do
    text :displaystring
  end
end