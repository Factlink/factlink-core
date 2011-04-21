class FactlinkSub
  include Mongoid::Document
  field :title
  field :content
  
  referenced_in :factlink_top, :inverse_of => :factlink_sub
end