class Comment < ActiveRecord::Base
  attr_accessible :content, :created_by_id, :fact_data_id
  attr_accessible :markup_format # nil is plain text
  belongs_to :fact_data, class_name: 'FactData'

  def created_by
    user = User.where(id: created_by_id).first
    user or fail "created by not found for comment '#{content}' user_id: #{created_by_id}"
  end

  def created_by=(user)
    self.created_by_id = user.id.to_s
  end

  def sub_comments
    SubComment.where(parent_id: self.id)
  end

  #index({ fact_data: 1, opinion: 1, created_at: 1})

  after_destroy do |comment|
    SubComment.destroy_all(parent_id: comment.id.to_s) #delete_all doesn't work?
  end
end
