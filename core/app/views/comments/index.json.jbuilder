json.array!(@comments) do |json, comment|
  json.partial! 'comments/comment', comment: comment
end
