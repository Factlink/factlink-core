require 'spec_helper'

describe 'user following' do
  include PavlovSupport

  let(:user1) { create :full_user }
  let(:user2) { create :full_user }
  let(:user3) { create :full_user }

  describe 'following a user' do
    describe 'following' do
      before do
        as(user1) do |pavlov|
          pavlov.interactor(:'users/follow_user', user_to_follow_username: user2.username)
          pavlov.interactor(:'users/follow_user', user_to_follow_username: user3.username)
        end
      end

      it 'returns that the current user follows user2 and user3' do
        as(user1) do |pavlov|
          result = pavlov.interactor(:'users/following', username: user1.username)
          expect(result.size).to eq 2
          expect(result.map(&:username))
            .to match_array [user2.username, user3.username]
        end
      end

      it 'returns that the other user is not following users' do
        as(user1) do |pavlov|
          result = pavlov.interactor(:'users/following', username: user2.username)
          expect(result.size).to eq 0
        end
      end
    end

    describe 'stream activities' do
      it "adds relevant activities" do
        a4 = nil

        as(user2) do |pavlov|
          a4 = Activity.create user: user2.graph_user,
            action: :followed_user, subject: user3.graph_user
        end

        as(user1) do |pavlov|
          pavlov.interactor(:'users/follow_user', user_to_follow_username: user2.username)
        end

        expect(user1.graph_user.stream_activities.ids)
          .to match_array [a4.id]
      end
    end
  end

  describe 'unfollowing a user' do
    before do
      as(user1) do |pavlov|
        pavlov.interactor(:'users/follow_user', user_to_follow_username: user2.username)
        pavlov.interactor(:'users/unfollow_user', username: user1.username, user_to_unfollow_username: user2.username)
      end
    end

    describe 'following' do
      it 'returns that the current user is not following users' do
        as(user1) do |pavlov|
          result = pavlov.interactor(:'users/following', username: user1.username)
          expect(result.size).to eq 0
        end
      end

      it 'returns that the other user is not following users' do
        as(user1) do |pavlov|
          result = pavlov.interactor(:'users/following', username: user2.username)
          expect(result.size).to eq 0
        end
      end
    end
  end

  describe 'unfollowing, following multiple times' do
    before do
      as(user1) do |pavlov|
        pavlov.interactor(:'users/unfollow_user', username: user1.username, user_to_unfollow_username: user2.username)
        pavlov.interactor(:'users/follow_user', user_to_follow_username: user2.username)
        pavlov.interactor(:'users/follow_user', user_to_follow_username: user2.username)
      end
    end

    describe 'following' do
      it 'returns that the current user follow the other user' do
        as(user1) do |pavlov|
          result = pavlov.interactor(:'users/following', username: user1.username)
          expect(result.size).to eq 1
          expect(result[0].username).to eq user2.username
        end
      end

      it 'returns that the other user is not following users' do
        as(user1) do |pavlov|
          result = pavlov.interactor(:'users/following', username: user2.username)
          expect(result.size).to eq 0
        end
      end
    end
  end

  describe 'following yourself' do
    it 'should not be allowed' do
      as(user1) do |pavlov|
        expect do
          pavlov.interactor(:'users/follow_user', user_to_follow_username: user1.username)
        end.to raise_error
      end
    end

    it 'should have no followers and following' do
      as(user1) do |pavlov|
        begin
          pavlov.interactor(:'users/follow_user', user_to_follow_username: user1.username)
        rescue
        end

        following = pavlov.interactor(:'users/following', username: user1.username)
        expect(following.size).to eq 0
      end
    end
  end


end
