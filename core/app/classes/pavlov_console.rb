# Usage:
#
# > console = PavlovConsole.new('mark')
# > console.interactor :'facts/post_to_twitter', '10', 'hi'

class PavlovConsole
  include Pavlov::Helpers

  def initialize username
    @username = username
  end

  def user
    @user ||= (User.find(@username) || raise("user not found"))
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
end
