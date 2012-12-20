class EvidenceDeletable
  attr_reader :evidence, :believable, :creator_id

  def initialize evidence, type, believable, creator_id
    @evidence = evidence
    @type = type
    @believable = believable
    @creator_id = creator_id
  end

  def deletable?
    (has_no_believers or creator_is_only_believer) and has_no_sub_comments
  end

  private
  def people_believes_ids
    @people_believes_ids ||= believable.people_believes.ids
  end

  def has_no_believers
    people_believes_ids == []
  end

  def creator_is_only_believer
    people_believes_ids.map {|i| i.to_i} == [creator_id.to_i]
  end

  def sub_comment_count
    Queries::SubComments::Count.new(evidence.id.to_s, @type).execute
  end

  def has_no_sub_comments
    sub_comment_count == 0
  end
end
