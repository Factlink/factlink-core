json.id          message.id.to_s
json.content     message.content
json.created_at  message.created_at
json.updated_at  message.updated_at
json.time_ago    time_ago_in_words(Time.at(message.created_at.to_time)) + " ago"
json.sender_id   message.sender_id.to_s

json.sender do |json|
  json.id message.sender_id.to_s
end
