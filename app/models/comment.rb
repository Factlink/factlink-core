class Comment < ActiveRecord::Base
  attr_accessible :content, :created_by_id, :fact_data_id
  attr_accessible :markup_format # nil is plain text
  belongs_to :fact_data, class_name: 'FactData'
  has_many :activities, as: :subject, dependent: :destroy
  has_many :sub_comments, foreign_key: :parent_id, inverse_of: :parent, dependent: :destroy

  def created_by
    user = User.where(id: created_by_id).first
    user or fail "created by not found for comment '#{content}' user_id: #{created_by_id}"
  end

  def created_by=(user)
    self.created_by_id = user.id.to_s
  end
end
