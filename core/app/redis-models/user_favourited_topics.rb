class UserFavouritedTopics

  attr_reader :graph_user_id, :relation
  private :relation

  def initialize graph_user_id, relation=DirectedRelationsWithReverse.new(Nest.new(:user)[:favourited_topics])
    @graph_user_id = graph_user_id
    @relation = relation
  end

  def favourite topic_id
    relation.add graph_user_id, topic_id
  end

  def unfavourite topic_id
    relation.remove graph_user_id, topic_id
  end

  def topic_ids
    relation.ids graph_user_id
  end

  def favourited? topic_id
    relation.has? graph_user_id, topic_id
  end

end
