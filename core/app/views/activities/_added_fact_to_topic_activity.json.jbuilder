channel = object

topic = query :'topics/by_slug_title_with_authority_and_facts_count', channel.slug_title

json.fact_displaystring truncate(subject.data.displaystring.to_s, length: 48)
json.fact_url friendly_fact_path(subject)

if subject.created_by.user == user
  json.posted 'posted'
else
  json.posted 'reposted'
end

json.topic { |j| j.partial! 'user_topics/user_topic', user_topic: topic }
json.fact { |j| j.partial! 'facts/fact', fact: subject }
