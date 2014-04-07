module ActivityMailerHelper
  def link_to_possibly_dead_user(dead_user, options={})
    link_to dead_user.name, user_profile_url(dead_user.username), options
  end
end
