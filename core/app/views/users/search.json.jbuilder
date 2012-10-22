json.array!(@users) do |json, user|
  json.username       user.username
end