class FactlinkSub
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :title, :type => String
  field :content, :type => String
  field :url, :type => String
  
  # referenced_in :factlink_top, :inverse_of => :factlink_sub
  belongs_to :factlink_top
end