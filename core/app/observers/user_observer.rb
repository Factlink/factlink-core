class UserObserver < Mongoid::Observer
  def after_update(user)
    if user.approved_changed? and user.approved?
      # Send mail
    end
  end
end