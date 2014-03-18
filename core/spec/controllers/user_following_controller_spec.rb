require 'spec_helper'

describe UserFollowingController do
  let (:user)  { create :user }

  render_views


  describe "#index" do
    include PavlovSupport
    before do
      FactoryGirl.reload

      user2 = create :user
      user3 = create :user

      as(user) do |p|
        p.interactor(:'users/follow_user', username: user2.username)
        p.interactor(:'users/follow_user', username: user3.username)
      end
    end

    it 'works' do
      authenticate_user!(user)

      get :index, username: user.username

      expect(response).to be_success
      verify { response.body }
    end
  end
end
