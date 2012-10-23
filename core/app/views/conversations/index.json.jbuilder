json.array!(@conversations) do |json, conversation|
  json.id            conversation.id
  json.fact_data_id  conversation.fact_data_id
  json.recipients    conversation.recipients, :id, :name, :gravatar_hash
  if conversation.last_message
    json.last_message do |json|
      json.id          conversation.last_message.id
      json.content     conversation.last_message.content
      json.created_at  conversation.last_message.created_at
      json.updated_at  conversation.last_message.updated_at
      json.sender_id   conversation.last_message.sender_id
    end
  end
end
