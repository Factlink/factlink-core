require 'spec_helper'

describe HomeController do

  # TODO factor out, because each controller needs this
  def authenticate_user!
    @user = FactoryGirl.create(:user)
    request.env['warden'] = mock(Warden, :authenticate => @user, :authenticate! => @user)
  end


  describe "GET index" do

    it "should be succesful" do
      get :index
      response.should be_succes
    end

    it "assigns @facts" do
      get :index
      assigns(:facts).should eq(Fact.all)
    end

    it "assigns @users" do
      get :index
      assigns(:users).should eq(User.all)
    end
   
    it "renders the index template" do
      get :index
      response.should render_template("index")
    end
    
  end


end