class Job
  include Mongoid::Document
  attr_accessible :title, :content, :show

  field :title, type: String
  field :content, type: String
  field :show, type: Boolean, default: false
end
