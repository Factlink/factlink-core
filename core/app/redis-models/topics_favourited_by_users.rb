class TopicsFavouritedByUsers

  attr_reader :topic_id, :relation
  private :relation

  def initialize topic_id, relation=DirectedRelationsWithReverse.new(Nest.new(:user)[:favourited_topics])
    @topic_id = topic_id
    @relation = relation
  end

  def favouritours_count
    relation.reverse_count topic_id
  end
end
