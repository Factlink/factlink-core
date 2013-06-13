class Console
  include Pavlov::Helper
  def initialize username
    @username = username
  end

  def user
    @user ||= (User.find(username) || raise("user not found"))
  end

  def ability
    @ability ||= Ability.new(user)
  end

  def pavlov_options
    {
      current_user: user,
      ability: ability
    }
  end

  def post_to_twitter(fact_id, message)
    id = Integer(fact_id).to_s

    interactor :'facts/post_to_twitter', fact_id, message
  end
end
