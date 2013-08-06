# Usage:
#
# > console = PavlovConsole.new('mark')
# > console.old_interactor :'facts/post_to_twitter', '10', 'hi'

class PavlovConsole
  include Pavlov::Helpers

  def initialize username
    @username = username
  end

  def user
    @user ||= (User.find(@username) || raise("user not found"))
  end

  def pavlov_options
    Util::PavlovContextSerialization.pavlov_context_by_user user
  end
end
