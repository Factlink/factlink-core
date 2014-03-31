class SubComment
  include Mongoid::Document
  include Mongoid::Timestamps

  # TODO: rename to :comment
  belongs_to :parent, class_name: 'Comment'

  field :content,           type: String

  field :created_by_id, type: Moped::BSON::ObjectId
  def created_by
    User.where(id: created_by_id).first
  end
  def created_by=(user)
    self[:created_by_id] = user.id
  end
end
