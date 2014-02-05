json.id           comment.id
json.created_at   comment.created_at
json.created_by do |json|
  json.partial! 'users/user_partial', user: comment.created_by
end
json.type         comment.type #rename: "type"

json.formatted_comment_content comment.formatted_content

json.fact_data do |json|
  json.partial! 'facts/fact_data_partial', fact_data: comment.fact_data
end

json.time_ago comment.time_ago

json.tally do |j|
  json.believes             comment.votes[:believes]
  json.disbelieves          comment.votes[:disbelieves]
  json.current_user_opinion comment.votes[:current_user_opinion]
end

json.is_deletable comment.deletable?

json.sub_comments_count comment.sub_comments_count
