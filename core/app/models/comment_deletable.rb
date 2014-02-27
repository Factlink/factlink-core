module CommentDeletable
  def self.deletable? comment
    has_subcomments = SubComment.where(parent_id: comment.id.to_s).exists?
    !has_subcomments
  end
end
