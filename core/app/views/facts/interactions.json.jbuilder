json.total @total
json.impact NumberFormatter.new(@impact).as_authority
json.users @users do |user|
  json.partial! 'users/user_partial', user: user
end
