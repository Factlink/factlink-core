module ControllerMethods
  include ::Devise::TestHelpers
  def authenticate_user!(user)
    request.env['warden'] = mock(Warden, :authenticate => user, :authenticate! => user)
  end
end