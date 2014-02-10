json.id           sub_comment.id
json.formatted_content FormattedCommentContent.new(sub_comment.content).html

json.created_at   sub_comment.created_at

json.created_by do |json|
  user_id = sub_comment.created_by_id
  user = Queries::UsersByIds.new(user_ids: [user_id]).call.first
  json.partial! 'users/user_partial', user: user
end
