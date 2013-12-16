require 'spec_helper'

describe FactsController do
  include PavlovSupport

  render_views

  let(:user) { create(:full_user) }

  describe :show do
    it "should render json successful" do
      FactoryGirl.reload

      authenticate_user!(user)
      fact = nil

      as(user) do |pavlov|
        fact = pavlov.interactor(:'facts/create',
                                     displaystring: 'displaystring',
                                     url: 'url',
                                     title: 'title',
                                     sharing_options: {})
        fact.add_opinion :believes, user.graph_user
      end

      ability.should_receive(:can?).with(:show, Fact).and_return(true)
      should_check_can :show, fact

      get :show, id: fact.id, format: :json

      Approvals.verify(response.body, format: :json, name: 'facts#show should keep the same content')
    end

    it "should render json successful for non-logged in users" do
      FactoryGirl.reload

      fact = nil

      as(user) do |pavlov|
        fact = pavlov.interactor(:'facts/create',
                                     displaystring: 'displaystring',
                                     url: 'url',
                                     title: 'title',
                                     sharing_options: {})
        fact.add_opinion :believes, user.graph_user
      end

      ability.should_receive(:can?).with(:show, Fact).and_return(true)
      should_check_can :show, fact

      get :show, id: fact.id, format: :json

      Approvals.verify(response.body, format: :json, name: 'facts#show should keep the same content for anonymous')
    end
  end

  describe :discussion_page do
    it "should escape html in fields" do
      authenticate_user!(user)
      fact = nil

      as(user) do |pavlov|
        fact = pavlov.interactor(:'facts/create',
                                     displaystring: 'displaystring',
                                     url: 'url',
                                     title: 'title',
                                     sharing_options: {})
      end

      fact.data.displaystring = "baas<xss> of niet"
      fact.data.title = "baas<xss> of niet"
      fact.data.save

      ability.stub can?: false
      ability.stub(:can?).with(:show, Fact).and_return(true)

      should_check_can :show, fact

      get :discussion_page, id: fact.id, fact_slug: 'hoi'
      response.body.should_not match(/<xss>/)
    end
  end

  describe :destroy do
    it "should delete the fact" do
      authenticate_user!(user)
      fact = nil

      as(user) do |pavlov|
        fact = pavlov.interactor(:'facts/create',
                                     displaystring: 'displaystring',
                                     url: 'url',
                                     title: 'title',
                                     sharing_options: {})
      end
      fact_id = fact.id

      ability.should_receive(:can?).with(:show, Fact).and_return(true)
      ability.should_receive(:can?).with(:manage, Fact).and_return(true)
      should_check_can :destroy, fact
      get :destroy, id: fact.id, format: :json
      response.should be_success

      Fact[fact_id].should == nil
    end
  end

  describe :create do
    it "should work with json" do
      authenticate_user!(user)
      post 'create', format: :json, url: "http://example.org/", displaystring: "Facity Fact", fact_title: "Title"
      response.code.should eq("200")
    end
  end

  describe :evidence_search do
    it "should work" do
      authenticate_user!(user)
      fact = nil

      as(user) do |pavlov|
        fact = pavlov.interactor(:'facts/create',
                                     displaystring: 'displaystring',
                                     url: 'url',
                                     title: 'title',
                                     sharing_options: {})
      end

      get :evidence_search, id: fact.id, s: "Baron"
      response.should be_success
    end
  end

  describe :share do
    it 'should work for twitter' do
      authenticate_user!(user)
      create :social_account, :twitter, user: user
      fact = nil
      as(user) do |pavlov|
        fact = pavlov.interactor(:'facts/create',
                                     displaystring: 'displaystring',
                                     url: 'url',
                                     title: 'title',
                                     sharing_options: {})
      end

      Twitter::Client.any_instance.should_receive(:update)
      Twitter.stub configuration: double(short_url_length_https: 20)

      post :share, id: fact.id, fact_sharing_options: {twitter: true}
    end

    it 'should work for facebook' do
      authenticate_user!(user)
      create :social_account, :facebook, user: user
      fact = nil
      as(user) do |pavlov|
        fact = pavlov.interactor(:'facts/create',
                                     displaystring: 'displaystring',
                                     url: 'url',
                                     title: 'title',
                                     sharing_options: {})
      end

      Koala::Facebook::API.any_instance.should_receive(:put_wall_post)

      post :share, id: fact.id, fact_sharing_options: {facebook: true}
    end
  end
end
