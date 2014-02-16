DeadSubComment = StrictStruct.new(:id, :created_by, :created_by_id, :created_at, :content, :parent_id) do
  def formatted_content
    FormattedCommentContent.new(content).html
  end

  def to_hash
    res = super.merge \
      formatted_content: formatted_content
    res.delete(:created_by_id)
    res.delete(:content)
    res.delete(:parent_id)
    res
  end
end
