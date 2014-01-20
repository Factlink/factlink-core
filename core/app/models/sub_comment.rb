class SubComment
  include Mongoid::Document
  include Mongoid::Timestamps

  # TODO: rename to :comment
  belongs_to :parent, class_name: 'Comment'

  field :content,           type: String
  belongs_to :created_by, class_name: 'User'

  def type
    parent.type
  end
end
