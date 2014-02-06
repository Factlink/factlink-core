json.extract! comment,
  :id,
  :created_at,
  :formatted_content,
  :time_ago,
  :tally,
  :is_deletable,
  :sub_comments_count

json.created_by do |json|
  json.partial! 'users/user_partial', user: comment.created_by
end
