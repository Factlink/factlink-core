class ReallyRemoveFact
  @queue = :zzz_janitor

  def self.perform fact_id
    fact = Fact[fact_id]

    fact.data.comments.each do |comment|
      SubComment.delete_all(parent_id: comment.id.to_s)
      comment.delete
    end

    fact.believable.delete
    fact.delete
  end
end
