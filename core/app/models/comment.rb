class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessor :authority

  belongs_to :fact_data, class_name: 'FactData'

  field :type,              type: String
  field :content,           type: String
  belongs_to :created_by, class_name: 'User', inverse_of: :comments

  index({ fact_data: 1, opinion: 1, created_at: 1})

  def deletable?
    EvidenceDeletable.new(self, Believable::Commentje.new(self), created_by.graph_user_id).deletable?
  end
end
