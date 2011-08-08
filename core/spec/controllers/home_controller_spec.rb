require 'spec_helper'

describe HomeController do
  include Devise::TestHelpers
  render_views

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

    it "should have the right title" do
      pending
      get :index      
      response.should have_selector('h1', :content => "credibility you can see")
    end


    it "assigns @facts" do
      get :index
      assigns(:facts).all.should =~ Fact.all.all
    end

    it "assigns @users" do
      get :index
      assigns(:users).to_a.should =~ User.all.to_a
    end

    it "renders the index template" do
      get :index
      response.should render_template("index")
    end

  end


end
