require 'spec_helper'

describe WheelController do
  include Devise::TestHelpers
  render_views

  # TODO factor out, because each controller needs this
  def authenticate_user!
    @user = FactoryGirl.create(:user)
    request.env['warden'] = mock(Warden, :authenticate => @user, :authenticate! => @user)
  end



  it "should be succesful" do
    get :show, :percentages => '15-15-70', :format => :png
    response.should be_redirect
  end

  describe "cap_percentages" do
    it {subject.cap_percentages([15,15,70],15,5).should == [15,15,70]}
  end
end
