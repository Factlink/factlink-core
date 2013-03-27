json.fact_displaystring truncate(subject.data.displaystring.to_s, length: 48)
json.fact_url friendly_fact_path(subject)

if subject.created_by.user == user
  json.posted 'posted'
else
  json.posted 'reposted'
end

json.translated_action "freefly"

# The Fact owner
if subject.created_by.user == current_user
  json.fact_owner "your"
elsif subject.created_by.user == object.created_by.user
  json.fact_owner "a"
else
  json.fact_owner "#{subject.created_by.user.username}'s"
end

# The Channel owner
if object.created_by.user == current_user
  json.channel_owner "your #{t(:topic)}"
else
  json.channel_owner "their #{t(:topic)}"
end

json.channel_owner_profile_url user_profile_path(object.created_by.user)
json.channel_title             object.title
json.channel_url               channel_path(object.created_by.user, object.id)

json.fact { |j| j.partial! 'facts/fact', fact: subject }
