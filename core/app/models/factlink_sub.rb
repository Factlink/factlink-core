class FactlinkSub
  include Mongoid::Document
  include Mongoid::Timestamps
  include Sunspot::Mongoid

  # Create search index on :displaystring
  # searchable do
  #   text :title
  # end

  field :title, :type => String
  field :content, :type => String
  field :url, :type => String

  belongs_to :factlink_top
  
end