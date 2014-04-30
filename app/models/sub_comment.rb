class SubComment < ActiveRecord::Base
  attr_accessible :content, :created_by_id, :parent_id

  # TODO: rename to :comment
  belongs_to :parent, class_name: 'Comment'

  belongs_to :created_by, class_name: :User
  has_many :activities, as: :subject, dependent: :destroy
end
