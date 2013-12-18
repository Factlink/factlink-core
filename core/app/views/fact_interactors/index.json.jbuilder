json.array!(@interactors) do |data|
  json.total  data[:total]
  json.impact data[:total]
  json.type   data[:type]
  json.users  data[:users] do |user|
    json.partial! 'users/user_partial', user: user
  end
end
