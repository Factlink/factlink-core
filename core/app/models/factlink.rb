# Used for development on the front-end
class Factlink
  include Mongoid::Document
  field :title, :type => String
  field :description, :type => String
  field :text, :type => String
  field :content, :type => String
  field :from_user, :type => String
  
  validates_presence_of :title
end