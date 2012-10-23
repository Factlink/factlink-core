json.id           @conversation.id
json.fact_data_id @conversation.fact_data_id
json.fact_id      @conversation.fact_id
json.messages @messages, :content, :id, :created_at, :updated_at, :sender_id
