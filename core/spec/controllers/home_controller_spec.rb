require 'spec_helper'

describe HomeController do
  include Devise::TestHelpers
  include ControllerMethods

  let (:user)  {FactoryGirl.create :user}
  
  render_views

  describe "GET index" do

    it "should be succesful" do
      get :index
      response.should be_succes
    end

    it "should work" do
      authenticate_user!(user)
      get :index
      response.should redirect_to(user_profile_path user)
    end


    it "assigns @facts" do
      get :index
      assigns(:facts).should =~ Fact.all.to_a
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

  describe "Search" do
    it "should render succesful" do
      get :search
      response.should be_succes
    end

    describe "when searching for something" do
      before do
        @f1 = FactoryGirl.create(:fact)
        @f1.data.displaystring = 10
        @f1.data.save
        @f2 = FactoryGirl.create(:fact)
        @f2.data.displaystring = 11
        @f2.data.save
        @f3 = FactoryGirl.create(:fact)
        @f3.data.displaystring = 12
        @f3.data.save
      end

      it "should return relevant results when a search parameter is given" do
        pending "Pending for deploy - SunSpot mock not working correct in test"
        result_set = [@f1.data, @f2.data, @f3.data]

        sunspot_search = mock(Sunspot::Search::StandardSearch)
        sunspot_search.stub!(:results).and_return { result_set }

        FactData.should_receive(:search).and_return(sunspot_search)

        post "search", :s => "1"
        assigns(:results).should =~ [@f1,@f2,@f3]
      end

      it "should return all results when no search parameter is given" do
        pending "Pending for deploy - SunSpot mock not working correct in test"
        result_set = [@f1.data, @f2.data, @f3.data]

        mock_criteria = mock(Mongoid::Criteria)

        mock_criteria.stub!(:skip).and_return { mock_criteria }
        mock_criteria.stub!(:limit).and_return { mock_criteria }

        mock_criteria.stub!(:to_a).and_return { result_set }

        FactData.should_receive(:all).and_return(mock_criteria)

        post "search"
        assigns(:results).should =~ [@f1,@f2,@f3]
      end
    end
  end
  
  describe "Routed to general pages should work" do
    it "should be routed to for valid templates" do
      {get: "/pages/about"}.should route_to controller: 'home', action: 'pages', name: 'about'
    end

    it "should not be routed with directory traversal" do
      {get: "/pages/../../../../etc/passwd"}.should_not be_routable
    end
    it "should be able to retrieve a valid template" do
      get :pages, name: 'about'
      response.should be_succes
    end
  end
end
