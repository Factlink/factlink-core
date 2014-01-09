json.id           comment.id
json.created_at   comment.created_at
json.created_by do |json|
  user = Queries::UsersByIds.new(user_ids: [comment.created_by_id]).call.first
  json.partial! 'users/user_partial', user: user
end
json.type         comment.type #rename: "type"

json.formatted_comment_content FormattedCommentContent.new(comment.content).html

json.fact_data do |json|
  json.partial! 'facts/fact_data_partial', fact_data: comment.fact_data
end

json.time_ago TimeFormatter.as_time_ago(comment.created_at)

json.tally do |j|
  j.partial! 'believable/votes', votes: comment.votes
end

json.is_deletable comment.deletable?

json.sub_comments_count comment.sub_comments_count
