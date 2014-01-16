json.array!(@evidence) do |evidence|
  json.partial! 'comments/comment', comment: evidence
end
