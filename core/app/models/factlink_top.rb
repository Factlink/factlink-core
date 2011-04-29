class FactlinkTop
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Taggable
  # include Sunspot::Mongoid

  # Create search index on :displaystring
  # searchable do
    # text :displaystring
  # end

  field :displaystring
  field :score, :type => Hash, :default => { :denies => 0, :weakens => 10, :supports => 120, :proves => 69 }
  
  belongs_to :site
  has_many :factlink_subs
  
  validates_presence_of :displaystring
  
  def to_s
    displaystring
  end

  def subs
    self.factlink_subs
  end

end