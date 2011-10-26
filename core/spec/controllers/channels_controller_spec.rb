require 'spec_helper'

describe ChannelsController do
  include Devise::TestHelpers
  render_views

  let (:user) {FactoryGirl.create(:user)}

  # TODO factor out, because each controller needs this
  def authenticate_user!(user)
    request.env['warden'] = mock(Warden, :authenticate => @user, :authenticate! => user)
  end
  

  it "should be succesful" do
    authenticate_user!(user)
    get :new, :username => user.username
    response.should be_succes
  end

end
