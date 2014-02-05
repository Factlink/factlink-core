DeadComment = StrictStruct.new(
  :id, :created_by, :created_at, :content, :type,
  :sub_comments_count, :created_by_id,
  :votes, :deletable?
) do

  def formatted_content
    FormattedCommentContent.new(content).html
  end

  def time_ago
    TimeFormatter.as_time_ago(created_at)
  end

  def tally
    votes.slice(:believes, :disbelieves, :current_user_opinion)
  end
end
