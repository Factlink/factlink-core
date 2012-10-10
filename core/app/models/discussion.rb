class Conversation
  include Mongoid::Document

  attr_accessible []

  belongs_to :subject, polymorphic: true
  has_many :messages

  has_and_belongs_to_many :recipients, class_name: 'User'
end
