class Activity < ActiveRecord::Base
  attr_accessible :action, :user_id, :created_at, :updated_at
  belongs_to :subject, polymorphic: true

  def self.valid_actions
    %w(created_comment created_sub_comment followed_user created_fact)
  end

  validates :action, inclusion: { in: valid_actions }

  def user=(new_user)
    self.user_id = new_user.id.to_s
  end

  def user
    User.where(id: user_id).first
  end

  # WARNING: if this method returns false, we assume it will never become
  #          valid again either, and remove/destroy freely.
  def still_valid?
    valid? and user_still_valid? and subject_still_valid?
  end

  private

  def user_still_valid?
    return true if not user_id
    return false unless user

    real_user = User.where(id: user.id).first

    real_user && !real_user.deleted
  end

  def subject_still_valid?
    return true unless subject_id

    subject
  end
end
