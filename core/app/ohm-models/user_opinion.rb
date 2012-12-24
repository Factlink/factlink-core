class UserOpinion
  def initialize(graph_user)
    @graph_user = graph_user
  end
  def on(fact)
    Opinion.types.each do |opinion|
      return opinion if has_opinion?(opinion,fact)
    end
    return nil
  end

  private
  def has_opinion?(type, fact)
    fact.opiniated(type).include? @graph_user
  end
end
