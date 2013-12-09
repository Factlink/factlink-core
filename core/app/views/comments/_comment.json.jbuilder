json.id           comment.id
json.created_at   comment.created_at
json.created_by do |json|
  json.partial! 'users/user_partial', user: comment.created_by
end
json.type         comment.type #rename: "type"
json.content      comment.content
json.fact_data do |json|
  json.partial! 'facts/fact_data_partial', fact_data: comment.fact_data
end

json.time_ago TimeFormatter.as_time_ago(comment.created_at)

json.argument_votes do |j|
  j.partial! 'believable/votes', votes: comment.votes
end

json.can_destroy? comment.can_destroy?

json.sub_comments_count comment.sub_comments_count
