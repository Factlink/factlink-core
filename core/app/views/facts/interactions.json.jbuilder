json.total @total
json.users @users do |json, user|
  json.partial! 'users/user_partial', user: user
end
