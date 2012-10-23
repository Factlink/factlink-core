json.id           @conversation.id
json.fact_data_id @conversation.fact_data_id
json.fact_id      @conversation.fact_id

json.recipients   @conversation.recipient_ids.map {|id| User.find(id).username }.delete_if { |username| username == current_user.username }.join(", ")

json.messages @messages do |json,message|
  json.content message.content
  json.id message.id
  json.created_at message.created_at
  json.updated_at message.updated_at

  json.time_ago time_ago_in_words(Time.at(message.created_at.to_time))

  sender = User.find(message.sender_id) # TODO: i want to be retrieved by an explicit query
  json.sender do |json|
    json.partial! 'users/user_partial', user: sender
  end
end
