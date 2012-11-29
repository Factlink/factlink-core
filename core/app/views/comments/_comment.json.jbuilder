json.id           comment.id
json.created_at   comment.created_at
json.created_by do |json|
  json.partial! 'users/user_partial', user: comment.created_by
  json.authority comment.authority
end
json.opinion      comment.opinion #rename: "type"
json.content      comment.content
json.fact_data do |json|
  json.partial! 'facts/fact_data_partial', fact_data: comment.fact_data
end

json.opinions OpinionPresenter.new comment.opinion_object
