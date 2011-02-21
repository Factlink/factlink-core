class Factlink
  include Mongoid::Document
  field :title, :type => String
  field :description, :type => String
  field :text, :type => String
  field :content, :type => String
  field :from_user, :type => String
  
  validates_presence_of :title
end


class FactlinkTop
  include Mongoid::Document
  field :displaystring
  
  references_many :factlink_subs
end


class FactlinkSub
  include Mongoid::Document
  field :title
  referenced_in :factlink_top, :inverse_of => :factlink_sub
  
end