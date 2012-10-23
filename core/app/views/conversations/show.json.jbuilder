json.id           @conversation.id
json.fact_data_id @conversation.fact_data_id
json.fact_id      @conversation.fact_id
json.messages @messages do |json,message|
  json.content message.content
  json.id message.id
  json.created_at message.created_at
  json.updated_at message.updated_at

  sender = User.find(message.sender_id) # TODO: i want to be retrieved by an explicit query
  json.sender do |json|
    json.partial! 'users/user_partial', user: sender
  end
end
