class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessible []

  belongs_to :conversation

  field :content,           type: String
  belongs_to :sender, class_name: 'User', inverse_of: :sent_messages
end
