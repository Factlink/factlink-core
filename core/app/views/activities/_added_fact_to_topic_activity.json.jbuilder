channel = object

topic = query :'user_topics/by_slug_title', channel.slug_title

json.fact_displaystring truncate(subject.data.displaystring.to_s, length: 48)
json.fact_url friendly_fact_path(subject)

if subject.created_by.user == user
  json.posted 'posted'
else
  json.posted 'reposted'
end

json.topic { |j| j.partial! 'topics/topic', topic: topic }
json.fact { |j| j.partial! 'facts/fact', fact: subject }
