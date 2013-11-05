json.id channel.id
json.title channel.title
json.slug_title channel.slug_title

json.created_by_authority NumberFormatter.new(channel.owner_authority).as_authority

user = channel.created_by_user
json.created_by do |j|
  j.partial! 'users/user_partial', user: user
end

json.followed? channel.containing_channel_ids.length > 0
