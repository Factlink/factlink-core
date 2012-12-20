json.array!(@sub_comments) do |json, sub_comment|
  json.partial! 'sub_comments/sub_comment', sub_comment: sub_comment
end
