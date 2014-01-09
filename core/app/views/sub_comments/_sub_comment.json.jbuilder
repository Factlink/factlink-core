json.id           sub_comment.id
json.formatted_comment_content FormattedCommentContent.new(sub_comment.content).html

json.time_ago     TimeFormatter.as_time_ago(sub_comment.created_at)

json.created_by do |json|
  json.partial! 'users/user_partial', user: sub_comment.created_by
end
