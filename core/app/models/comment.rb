class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :fact_data, class_name: 'FactData'

  field :content,           type: String
  belongs_to :created_by, class_name: 'User', inverse_of: :comments

  has_many :sub_comments, inverse_of: :parent

  index({ fact_data: 1, opinion: 1, created_at: 1})

  after_destroy do |comment|
    SubComment.destroy_all(parent_id: comment.id.to_s) #delete_all doesn't work?
  end
end
