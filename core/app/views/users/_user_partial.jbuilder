json.id             user.id.to_s
json.name           user.name.to_s.empty? ? user.username : user.name
json.username       user.username
json.gravatar_hash  user.gravatar_hash
