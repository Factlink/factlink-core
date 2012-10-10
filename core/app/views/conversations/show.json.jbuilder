json.id @conversation.id
json.subject do |json|
  json.type @conversation.subject_type
  json.id   @conversation.subject_id
end

json.messages @messages, :sender, :content