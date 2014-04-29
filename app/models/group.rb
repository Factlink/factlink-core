class Group < ActiveRecord::Base
  attr_accessible :groupname

  validates_presence_of     :groupname
  validates_length_of       :groupname, minimum:3

  has_and_belongs_to_many :users
  has_many :fact_data
end
