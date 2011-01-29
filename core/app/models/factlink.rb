class Factlink
  include Mongoid::Document
  field :title, :type => String
  field :description, :type => String
  field :content, :type => String
  
  validates_presence_of :title
end
