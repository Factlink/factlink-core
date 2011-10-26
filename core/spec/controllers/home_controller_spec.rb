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

  describe :search do
    it "should render succesful" do
      get :search
      response.should be_succes
    end

     it "should return relevant results when a search parameter is given" do      
       result_set = (
         [FactData.new(:displaystring => 10), FactData.new(:displaystring => 12), FactData.new(:displaystring => 13)].
            map {|fd| fd.fact }
       )

       sunspot_search = mock(Sunspot::Search::StandardSearch)
       sunspot_search.stub!(:results).and_return { result_set }

       FactData.should_receive(:search).and_return(sunspot_search)

       post "search", :s => "1"
       assigns(:results).should == result_set
     end

     it "should return all results when no search parameter is given" do
       result_set = (
         [FactData.new(:displaystring => 10), FactData.new(:displaystring => 12), FactData.new(:displaystring => 13)].
           map {|fd| fd.fact }
       )

       mock_criteria = mock(Mongoid::Criteria)

       mock_criteria.stub!(:skip).and_return { mock_criteria }
       mock_criteria.stub!(:limit).and_return { mock_criteria }

       mock_criteria.stub!(:to_a).and_return { result_set }

       FactData.should_receive(:all).and_return(mock_criteria)

       post "search"
       assigns(:results).should == result_set
     end

  end
  
end
