json.total @total
json.users @users do |user|
  json.partial! 'users/user_partial', user: user
end
