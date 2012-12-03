# HACK# HACK# HACK# HACK# HACK# HACK# HACK# HACK# HACK# HACK# HACK
# HACK# HACK# HACK# HACK# HACK# HACK# HACK# HACK# HACK# HACK# HACK
# HACK# HACK# HACK# HACK# HACK# HACK# HACK# HACK# HACK# HACK# HACK
# HACK# HACK# HACK# HACK# HACK# HACK# HACK# HACK# HACK# HACK# HACK
def has_opinion?(type, comment)
  believable = Believable::Commentje.new(comment.id.to_s)
  believable.opiniated(type).include? current_graph_user
end

def opinion_on(comment)
  Opinion.types.each do |opinion|
    return opinion if has_opinion?(opinion,comment)
  end
  return nil
end

# HACK! Refactor this...
current_user_opinion = opinion_on comment

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

json.current_user_opinion current_user_opinion
