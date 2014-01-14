json.array!(@votes) do |vote|
  json.username vote[:user].username
  json.user do
    json.partial! 'users/user_partial', user: vote[:user]
   end
  json.type vote[:type]
 end
