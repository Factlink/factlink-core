require 'resque/server'

class FactlinkUI::Resque < Resque::Server
  # Will redirect back to rails app to require a sign in
  before do
    if env['warden'].authenticate! and !env['warden'].user.admin?
      throw(:warden)
    end
  end
end
