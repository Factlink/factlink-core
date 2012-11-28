# hack to both be able to use this as partial and show
comment ||= @comment

# HACK: This shortcut of using `fact_relation.fact` instead of `fact_relation`
# is possible because in the current calculation these authorities are the same
comment.authority = Authority.on(comment.fact_data.fact, for: comment.created_by.graph_user).to_s(1.0)

json.id           comment.id
json.created_at   comment.created_at
json.created_by do |json|
  json.partial! 'users/user_partial', user: comment.created_by
  json.authority comment.authority
end
json.opinion      comment.opinion
json.content      comment.content
json.fact_data do |json|
  json.partial! 'facts/fact_data_partial', fact_data: comment.fact_data
end
