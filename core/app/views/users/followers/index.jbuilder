json.array! @users do |user|
  json.partial! 'users/user_partial', user: user
end
