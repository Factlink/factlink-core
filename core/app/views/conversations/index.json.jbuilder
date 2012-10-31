json.array!(@conversations) do |json, conversation|

  json.id conversation.id.to_s
  json.fact_data_id  conversation.fact_data_id.to_s

  json.recipients conversation.recipients do |json, recipient|
    json.partial! 'users/user_partial', user: recipient
  end

  if conversation.last_message
    json.last_message do |json|
      json.partial! 'conversations/message', message: conversation.last_message
    end
  end
end
