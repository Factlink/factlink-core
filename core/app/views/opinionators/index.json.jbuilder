json.array!(@interactors) do |vote|
  json.user do
    json.partial! 'users/user_partial', user: vote[:user]
   end
  json.type vote[:type]
 end

