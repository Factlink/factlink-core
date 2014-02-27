class EvidenceDeletable
  attr_reader :evidence

  def initialize evidence
    @evidence = evidence
  end

  def deletable?
    has_subcomments = SubComment.where(parent_id: evidence.id.to_s).exists?
    !has_subcomments
  end
end
