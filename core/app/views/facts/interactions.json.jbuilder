json.total @total
json.impact @impact
json.users @users do |user|
  json.partial! 'users/user_partial', user: user
end
