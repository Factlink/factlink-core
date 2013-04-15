channel = object
topic = channel.topic

json.fact_displaystring truncate(subject.data.displaystring.to_s, length: 48)
json.fact_url friendly_fact_path(subject)

if subject.created_by.user == user
  json.posted 'posted'
else
  json.posted 'reposted'
end

json.channel_title             topic.title
json.channel_url               topic_path(topic.slug_title)

json.fact { |j| j.partial! 'facts/fact', fact: subject }
