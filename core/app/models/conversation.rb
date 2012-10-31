class Conversation
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessible []

  belongs_to :fact_data, class_name: 'FactData'

  has_many :messages
  has_and_belongs_to_many :recipients, class_name: 'User'
end
