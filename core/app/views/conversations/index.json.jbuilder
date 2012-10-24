json.array!(@conversations) do |json, conversation|

  json.id conversation.id.to_s
  json.fact_data_id  conversation.fact_data_id.to_s

  json.recipients conversation.recipients do |json, recipient|
    json.partial! 'users/user_partial', user: recipient
  end

  if conversation.last_message
    json.last_message do |json|
      json.id          conversation.last_message.id.to_s
      json.content     conversation.last_message.content
      json.created_at  conversation.last_message.created_at
      json.updated_at  conversation.last_message.updated_at
      json.sender do |json|
        json.id conversation.last_message.sender_id.to_s
      end
    end
  end
end
