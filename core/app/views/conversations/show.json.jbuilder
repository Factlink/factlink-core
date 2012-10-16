json.id @conversation.id
json.fact_data_id @conversation.fact_data_id
json.messages @messages, :sender, :content
