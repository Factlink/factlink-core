class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :fact_data, class_name: 'FactData'

  field :content,           type: String

  field :created_by_id, type: Moped::BSON::ObjectId
  def created_by
    User.where(id: created_by_id).first
  end
  def created_by=(user)
    self[:created_by_id] = user.id
  end


  has_many :sub_comments, inverse_of: :parent

  index({ fact_data: 1, opinion: 1, created_at: 1})

  after_destroy do |comment|
    SubComment.destroy_all(parent_id: comment.id.to_s) #delete_all doesn't work?
  end
end
