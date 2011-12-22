class Job
  include Mongoid::Document
  field :title, :type => String
  field :content, :type => String
  field :show, :type => Boolean, :default => false
end
