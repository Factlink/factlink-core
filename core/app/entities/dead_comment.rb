DeadComment = StrictStruct.new(
  :id, :created_by, :created_at, :content,
  :sub_comments_count,
  :tally, :is_deletable
) do

  def formatted_content
    FormattedCommentContent.new(content).html
  end


  alias :old_to_h :to_h
  def to_h
    res = old_to_h.merge formatted_content: formatted_content
    res.delete(:content)
    res
  end

  alias :to_hash :to_h
end
