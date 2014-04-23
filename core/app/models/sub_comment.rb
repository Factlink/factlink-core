class SubComment < ActiveRecord::Base
  attr_accessible :content, :created_by_id, :parent_id


  # TODO: rename to :comment
  belongs_to :parent, class_name: 'Comment'

  def created_by
    User.where(id: created_by_id).first
  end

  def created_by=(user)
    self.created_by_id = user.id.to_s
  end
end
