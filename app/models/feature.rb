class Feature < ActiveRecord::Base
  attr_accessible :name
  belongs_to :user
end
