json.partial! 'topics/topic', topic: user_topic
json.current_user_authority NumberFormatter.new(user_topic.authority).as_authority
json.facts_count user_topic.facts_count
