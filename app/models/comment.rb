class Comment < ActiveRecord::Base
  attr_accessible :content, :created_by_id, :fact_data_id
  attr_accessible :markup_format
  belongs_to :fact_data, class_name: 'FactData'
  belongs_to :created_by, class_name: :User
  has_many :activities, as: :subject, dependent: :destroy
  has_many :sub_comments, foreign_key: :parent_id, inverse_of: :parent, dependent: :destroy
  has_many :comment_votes, dependent: :destroy
end
