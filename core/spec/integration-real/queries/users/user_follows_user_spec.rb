require 'spec_helper'

describe Queries::Users::UserFollowsUser do
  include PavlovSupport

  describe '#call' do

    it "should return false if the from_user doesn't follow the to_user" do
      from_user = create :full_user
      to_user = create :full_user

      as(from_user) do |pavlov|
        result = pavlov.query 'users/user_follows_user', from_graph_user_id: from_user.graph_user_id,
                                                         to_graph_user_id: to_user.graph_user_id

        expect(result).to be_false
      end
    end

    it "should return true if the from_user does follow the to_user" do
      from_user = create :full_user
      to_user = create :full_user

      as(from_user) do |pavlov|
        pavlov.interactor(:'users/follow_user', user_name: from_user.username, user_to_follow_user_name: to_user.username)

        result = pavlov.query 'users/user_follows_user', from_graph_user_id: from_user.graph_user_id,
                                                         to_graph_user_id: to_user.graph_user_id

        expect(result).to be_true
      end
    end

    it "should return false after unfollowing again" do
      from_user = create :full_user
      to_user = create :full_user

      as(from_user) do |pavlov|
        pavlov.interactor(:'users/follow_user', user_name: from_user.username, user_to_follow_user_name: to_user.username)
        pavlov.interactor(:'users/unfollow_user', user_name: from_user.username, user_to_unfollow_user_name: to_user.username)

        result = pavlov.query 'users/user_follows_user', from_graph_user_id: from_user.graph_user_id,
                                                         to_graph_user_id: to_user.graph_user_id

        expect(result).to be_false
      end
    end
  end
end
