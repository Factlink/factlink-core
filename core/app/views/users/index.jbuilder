json.array!(@users) do |json, user|
  json.partial! 'user_partial', user: user
end
