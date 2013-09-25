require 'spec_helper'

describe Queries::Users::UserFollowsUser do
  include PavlovSupport

  describe '#call' do

    let(:from_user) {create :full_user}
    let(:to_user) {create :full_user}

    let(:query) {described_class.new from_graph_user_id: from_user.graph_user_id,
                                  to_graph_user_id: to_user.graph_user_id}

    it "should return false if the from_user doesn't follow the to_user" do
      expect(query.call).to be_false
    end

    it "should return true if the from_user does follow the to_user" do
      as(from_user) do |pavlov|
        pavlov.interactor(:'users/follow_user', user_name: from_user.username, user_to_follow_user_name: to_user.username)
      end

      expect(query.call).to be_true
    end

    it "should return false after unfollowing again" do
      as(from_user) do |pavlov|
        pavlov.interactor(:'users/follow_user', user_name: from_user.username, user_to_follow_user_name: to_user.username)
        pavlov.interactor(:'users/unfollow_user', user_name: from_user.username, user_to_unfollow_user_name: to_user.username)
      end

      expect(query.call).to be_false
    end
  end
end
