class MigrateFactRelationToCommentWorker
  @queue = :aaa_migration

  def self.perform fact_relation_id
    fact_relation = FactRelation[fact_relation_id]

    comment = comment_for_fact_relation(fact_relation)
    move_opinionators fact_relation, comment
    move_subcomments fact_relation, comment

    fact_relation.delete
  end

  def self.comment_for_fact_relation fact_relation
    comment = Comment.new
    comment.created_at = fact_relation.created_at
    comment.updated_at = fact_relation.updated_at
    comment.created_by_id = fact_relation.created_by.user_id
    comment.fact_data_id = fact_relation.fact.data_id
    comment.type = fact_relation.type

    from_fact = fact_relation.from_fact
    if from_fact.site.nil?
      comment.content = from_fact.data.displaystring
    else
      fact_url = FactUrl.new(from_fact)
      comment.content = fact_url.friendly_fact_url
    end

    comment.save!

    comment
  end

  def self.move_opinionators fact_relation, comment
    fact_relation_believable = fact_relation.believable
    comment_believable = comment.believable

    [:believes, :disbelieves, :doubts].each do |opinion|
      fact_relation_believable.opiniated(opinion).each do |graph_user|
        comment_believable.add_opiniated(opinion, graph_user)
      end
    end

    fact_relation_believable.delete
  end

  def self.move_subcomments fact_relation, comment
    SubComment.where(parent_id: fact_relation.id)
              .update_all(parent_id: comment.id.to_s)
  end
end
