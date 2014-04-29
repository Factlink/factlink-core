require 'spec_helper'

describe 'user following' do
  include PavlovSupport

  let(:user1) { create :user }
  let(:user2) { create :user }
  let(:user3) { create :user }

  describe 'following a user' do
    describe 'following' do
      before do
        as(user1) do |pavlov|
          pavlov.interactor(:'users/follow_user', username: user2.username)
          pavlov.interactor(:'users/follow_user', username: user3.username)
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
  end

  describe 'unfollowing a user' do
    before do
      as(user1) do |pavlov|
        pavlov.interactor(:'users/follow_user', username: user2.username)
        pavlov.interactor(:'users/unfollow_user', username: user2.username)
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
        pavlov.interactor(:'users/unfollow_user', username: user2.username)
        pavlov.interactor(:'users/follow_user', username: user2.username)
        pavlov.interactor(:'users/follow_user', username: user2.username)
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
          pavlov.interactor(:'users/follow_user', username: user1.username)
        end.to raise_error
      end
    end

    it 'should have no followers and following' do
      as(user1) do |pavlov|
        begin
          pavlov.interactor(:'users/follow_user', username: user1.username)
        rescue
        end

        following = pavlov.interactor(:'users/following', username: user1.username)
        expect(following.size).to eq 0
      end
    end
  end


end
