require 'spec_helper'

describe Queries::Users::UserFollowsUser do
  include PavlovSupport

  describe '#call' do

    it "should return false if the from_user doesn't follow the to_user" do
      from_user = create :user
      to_user = create :user

      as(from_user) do |pavlov|
        result = pavlov.query 'users/user_follows_user', from_graph_user_id: from_user.graph_user_id,
                                                         to_graph_user_id: to_user.graph_user_id

        expect(result).to be_false
      end
    end

    it "should return true if the from_user does follow the to_user" do
      from_user = create :user
      to_user = create :user

      as(from_user) do |pavlov|
        pavlov.interactor(:'users/follow_user', username: to_user.username)

        result = pavlov.query 'users/user_follows_user', from_graph_user_id: from_user.graph_user_id,
                                                         to_graph_user_id: to_user.graph_user_id

        expect(result).to be_true
      end
    end

    it "should return false after unfollowing again" do
      from_user = create :user
      to_user = create :user

      as(from_user) do |pavlov|
        pavlov.interactor(:'users/follow_user', username: to_user.username)
        pavlov.interactor(:'users/unfollow_user', username: to_user.username)

        result = pavlov.query 'users/user_follows_user', from_graph_user_id: from_user.graph_user_id,
                                                         to_graph_user_id: to_user.graph_user_id

        expect(result).to be_false
      end
    end
  end
end
