json.array!(@conversations) do |json, conversation|
  json.id            conversation.id
  json.fact_data_id  conversation.fact_data_id
  json.recipient_ids conversation.recipient_ids
end
