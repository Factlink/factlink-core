require 'spec_helper'

describe UserFollowingController do
  let (:user)  { create :full_user }

  render_views


  describe "#index" do
    include PavlovSupport
    before do
      user2 = create :user
      user3 = create :user

      as(user) do |p|
        p.interactor(:'users/follow_user', user_name: user.username, user_to_follow_user_name: user2.username)
        p.interactor(:'users/follow_user', user_name: user.username, user_to_follow_user_name: user3.username)
      end
    end

    it 'works' do
      authenticate_user!(user)

      get :index, username: user.username

      expect(response).to be_success
      verify(format: :json) { response.body }
    end
  end
end
