class Activity < ActiveRecord::Base
  attr_accessible :action, :created_at, :updated_at
  belongs_to :subject, polymorphic: true
  belongs_to :user

  def self.valid_actions
    %w(created_comment created_sub_comment followed_user created_fact)
  end

  validates :action, inclusion: { in: valid_actions }
end
