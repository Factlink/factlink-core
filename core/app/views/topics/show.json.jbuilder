json.partial! 'topics/topic', topic: @topic

json.current_user_authority @topic.formatted_current_user_authority
