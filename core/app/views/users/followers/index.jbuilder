json.total @total
json.followed_by_me @followed_by_me
json.users @users do |json, user|
  json.partial! 'users/user_partial', user: user
end
