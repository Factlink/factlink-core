channel = object
topic = query(:'topics/by_slug_title_with_statistics', slug_title: channel.slug_title)

if subject.created_by.user == user
  json.posted 'posted'
else
  json.posted 'reposted'
end

json.topic { |j| j.partial! 'topics/topic_with_statistics', topic: topic }
json.fact { |j| j.partial! 'facts/fact', fact: subject }
