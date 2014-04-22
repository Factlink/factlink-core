class CommentVote < ActiveRecord::Base
  attr_accessible :comment_id, :opinion, :user_id, :created_at, :updated_at

  validates_inclusion_of :opinion, in: ['believes', 'disbelieves']
end
