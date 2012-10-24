json.id           @conversation.id
json.fact_data_id @conversation.fact_data_id
json.fact_id      @conversation.fact_id

json.recipients @recipients do |json, recipient|
  json.partial! 'users/user_partial', user: recipient
end

json.messages @messages do |json, message|
  json.content message.content
  json.id message.id
  json.created_at message.created_at
  json.updated_at message.updated_at
  json.time_ago time_ago_in_words(Time.at(message.created_at.to_time))

  json.sender do |json|
    json.id message.sender_id.to_s
  end
end
