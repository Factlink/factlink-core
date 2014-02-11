DeadComment = StrictStruct.new(
  :id, :created_by, :created_at, :content,
  :sub_comments_count, :created_by_id,
  :votes, :is_deletable
) do

  def formatted_content
    FormattedCommentContent.new(content).html
  end

  def tally
    votes.slice(:believes, :disbelieves, :current_user_opinion)
  end

  alias :old_to_h :to_h
  def to_h
    res = old_to_h.merge \
      formatted_content: formatted_content,
      tally: tally
    res.delete(:created_by_id)
    res.delete(:votes)
    res.delete(:content)
    res
  end

  def serializable_hash(*args)
    to_h
  end
  def to_hash(*args)
    to_h
  end
  def as_json(*args)
    to_h
  end
end
