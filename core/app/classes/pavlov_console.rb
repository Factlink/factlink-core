# Usage:
#
# > console = PavlovConsole.new('mark')
# > console.command :'twitter/share_factlink', fact_id: '10'

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
