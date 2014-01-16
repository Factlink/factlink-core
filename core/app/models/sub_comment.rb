class SubComment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :parent_id
  field :content,           type: String
  belongs_to :created_by, class_name: 'User'

  def parent
    Comment.find(parent_id)
  end

  def type
    parent.type
  end
end
