DeadComment = StrictStruct.new(
  :id, :created_by, :created_at, :content, :type,
  :sub_comments_count, :created_by_id,
  :votes, :is_deletable
) do

  def formatted_content
    FormattedCommentContent.new(content).html
  end

  def tally
    votes.slice(:believes, :disbelieves, :current_user_opinion)
  end
end
