json.array!(@sub_comments) do |sub_comment|
  json.partial! 'sub_comments/sub_comment', sub_comment: sub_comment
end
