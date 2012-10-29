json.id           @conversation.id
json.fact_data_id @conversation.fact_data_id
json.fact_id      @conversation.fact_id

json.recipients @conversation.recipients do |json, recipient|
  json.partial! 'users/user_partial', user: recipient
end

json.messages @conversation.messages do |json, message|
  json.partial! 'conversations/message', message: message
end
