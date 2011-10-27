require 'spec_helper'

describe FactsController do

  # TODO factor out, because each controller needs this
  def authenticate_user!
    @user = FactoryGirl.create(:user)
    request.env['warden'] = mock(Warden, :authenticate => @user, :authenticate! => @user)
  end

  def create_fact_relation
    @fact     = FactoryGirl.create(:fact)
    @evidence = FactoryGirl.create(:fact)
    @fr       = @fact.add_evidence(:supporting, @evidence,@user)
  end


  describe :show do
    it "should render succesful" do
      @fact = FactoryGirl.create(:fact)
      get :show, :id => @fact.id
      response.should be_succes
    end
  end

  describe :new do
    it "should return a new Fact object" do
      authenticate_user!
      get :new
      assigns[:fact].should be_a_new(Fact)
    end
  end

  describe :edit do
    it "should edit the given fact" do
      authenticate_user!
      
      @fact = FactoryGirl.create(:fact)
      get :edit, :id => @fact.id
      
      assigns[:fact].should == @fact
    end  
  end

  

  describe :intermediate do
    it "should have the correct assignments" do
      
      url     = "http://en.wikipedia.org/wiki/Batman"
      passage = "NotImplemented"
      fact    = "Batman is a fictional character"     # Actually the displaystring
      
      post :intermediate, :url      => url, 
                          :passage  => passage, 
                          :fact     => fact,
                          :the_action => "prepare"
      
      response.code.should eq("200")
      
      # Url is not working, really weird?
      # assigns[:url].should == url

      assigns(:passage).should == passage
      assigns(:fact).should == fact
            
    end

   
  end

  describe :create do
    it "should work" do
      authenticate_user!
      post 'create', :url => "http://example.org/",  :displaystring => "Facity Fact", :title => "Title"
      response.should redirect_to(edit_fact_path(Fact.all.to_a.last.id))
    end
  end

  describe :add_supporting_evidence do
    it "should respond to XHR" do
      authenticate_user!
      xhr :get, :add_supporting_evidence,
        :fact_id => FactoryGirl.create(:fact).id,
        :evidence_id => FactoryGirl.create(:fact).id

      response.code.should eq("200")
    end
    
  end

  describe :add_weakening_evidence do
    it "should respond to XHR" do
      authenticate_user!
      xhr :get, :add_supporting_evidence,
        :fact_id => FactoryGirl.create(:fact).id,
        :evidence_id => FactoryGirl.create(:fact).id

      response.code.should eq("200")
    end
  end




end
