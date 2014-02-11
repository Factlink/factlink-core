DeadComment = StrictStruct.new(
  :id, :created_by, :created_at, :formatted_content,
  :sub_comments_count,
  :tally, :is_deletable
) do

  alias :to_hash :to_h
end
