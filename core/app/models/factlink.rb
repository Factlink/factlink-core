class Factlink
  include Mongoid::Document
  field :title, :type => String
  field :description, :type => String
  field :text, :type => String
  field :content, :type => String
  field :from_user, :type => String
  
  validates_presence_of :title
end


class Site
  include Mongoid::Document
  field :url

  references_many :factlink_tops, :stored_as => :array, :inverse_of => :sites  
end

class FactlinkTop
  include Mongoid::Document
  field :displaystring

  references_many :sites, :stored_as => :array, :inverse_of => :factlink_tops
  references_many :factlink_subs, :type => Array, :default => []
end


class FactlinkSub
  include Mongoid::Document
  field :title
  field :content
  
  referenced_in :factlink_top, :inverse_of => :factlink_sub
end