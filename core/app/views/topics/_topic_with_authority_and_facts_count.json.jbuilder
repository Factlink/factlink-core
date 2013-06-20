json.partial! 'topics/topic', topic: topic
json.current_user_authority NumberFormatter.new(topic.current_user_authority).as_authority
json.facts_count topic.facts_count
