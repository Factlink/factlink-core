json.array!(@tour_users) do |user|
  json.partial! 'user_partial', user: user
end
