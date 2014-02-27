class EvidenceDeletable
  attr_reader :evidence, :believable, :creator_id

  def initialize evidence, believable, creator_id
    @evidence = evidence
    @type = type
    @believable = believable
    @creator_id = creator_id
  end

  def deletable?
    has_subcomments = SubComment.where(parent_id: evidence.id.to_s).exists?
    !has_subcomments
  end
end
