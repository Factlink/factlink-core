json.partial! 'topics/topic', topic: @topic

# TODO: make sure that other points in the backend also return topic authority where applicable
json.current_user_authority NumberFormatter.new(@topic.current_user_authority).as_authority
