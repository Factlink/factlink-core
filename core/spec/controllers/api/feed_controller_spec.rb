require 'spec_helper'

describe Api::FeedController do
  render_views

  let(:user) { create :user }

  describe "#index" do
    include PavlovSupport

    before do
      FactoryGirl.reload
      other_user = create :user
      as(user) do |p|
        p.interactor :'users/follow_user', username: user.username, user_to_follow_username: other_user.username
      end

      fact = create :fact
      as(other_user) do |p|
        p.interactor :'comments/create', fact_id: fact.id.to_i, content: 'hoi'
      end

      fact2 = create :fact
      comment2 = nil
      as(user) do |p|
        comment2 = p.interactor :'comments/create', fact_id: fact2.id.to_i, content: 'hoi'
      end
      as(other_user) do |p|
        p.interactor :'sub_comments/create', comment_id: comment2.id.to_s, content: 'hoi'
      end

      as(other_user) do |p|
        p.interactor :'users/follow_user', username: other_user.username, user_to_follow_username: (create :user).username
        p.interactor :'users/follow_user', username: other_user.username, user_to_follow_username: (create :user).username
      end
    end

    it "should render" do
      authenticate_user!(user)
      get :index, format: :json, username: user.username

      response.should be_success
      verify { response.body }
    end
  end

end
