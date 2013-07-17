json.total @data[:total]
json.impact @data[:impact]
json.users @data[:users] do |user|
  json.partial! 'users/user_partial', user: user
end
