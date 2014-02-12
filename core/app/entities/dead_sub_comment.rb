DeadSubComment = StrictStruct.new(:id, :created_by, :created_by_id, :created_at, :content, :parent_id) do
  alias :old_to_h :to_h
  def formatted_content
    FormattedCommentContent.new(content).html
  end

  def to_h
    res = old_to_h.merge \
      formatted_content: formatted_content
    res.delete(:created_by_id)
    res.delete(:content)
    res.delete(:parent_id)
    res
  end

  alias :to_hash :to_h
end
