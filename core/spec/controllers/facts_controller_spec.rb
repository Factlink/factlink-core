require 'spec_helper'

describe FactsController do

  def authenticate_user!
    @user = FactoryGirl.create(:user)
    request.env['warden'] = mock(Warden, :authenticate => @user, :authenticate! => @user)
  end

  before(:each) do
  end

  it "should have a working factlinks_for_url" do
    pending
    get :factlinks_for_url
    assigns[:json].should == []
  end

  describe :new do
    it "should work" do
      authenticate_user!
      get :new
      assigns[:factlink].should be_a(Fact)
    end
  end

end
