require 'spec_helper'

describe 'user following' do
  include Pavlov::Helpers

  let(:current_user) { create :user }
  let(:other_user)   { create :user }
  let(:third_user)   { create :user }

  def pavlov_options
    {current_user: current_user}
  end

  describe 'following a user' do
    before do
      interactor :'users/follow_user', current_user.username, other_user.graph_user_id
      interactor :'users/follow_user', current_user.username, third_user.graph_user_id
    end

    describe 'followers' do
      it 'returns that the current user has no followers' do
        result = interactor :'users/followers', current_user.username, 0, 10

        expect(result[0].size).to eq 0
      end

      it 'returns that the other user has current_user as follower' do
        result = interactor :'users/followers', other_user.username, 0, 10

        expect(result[0].size).to eq 1
        expect(result[0][0].username).to eq current_user.username
      end
    end

    describe 'following' do
      it 'returns that the current user follows other_user and third_user' do
        result = interactor :'users/following', current_user.username, 0, 10

        expect(result[0].size).to eq 2
        expect(result[0][0].username).to eq other_user.username
        expect(result[0][1].username).to eq third_user.username
      end

      it 'returns that the other user is not following users' do
        result = interactor :'users/following', other_user.username, 0, 10

        expect(result[0].size).to eq 0
      end
    end
  end

  describe 'unfollowing a user' do
    before do
      interactor :'users/follow_user', current_user.username, other_user.graph_user_id
      interactor :'users/unfollow_user', current_user.username, other_user.graph_user_id
    end

    describe 'followers' do
      it 'returns that the current user has no followers' do
        result = interactor :'users/followers', current_user.username, 0, 10

        expect(result[0].size).to eq 0
      end

      it 'returns that the other user has no followers' do
        result = interactor :'users/followers', other_user.username, 0, 10

        expect(result[0].size).to eq 0
      end
    end

    describe 'following' do
      it 'returns that the current user is not following users' do
        result = interactor :'users/following', current_user.username, 0, 10

        expect(result[0].size).to eq 0
      end

      it 'returns that the other user is not following users' do
        result = interactor :'users/following', other_user.username, 0, 10

        expect(result[0].size).to eq 0
      end
    end
  end

  describe 'unfollowing, following multiple times' do
    before do
      interactor :'users/unfollow_user', current_user.username, other_user.graph_user_id
      interactor :'users/follow_user', current_user.username, other_user.graph_user_id
      interactor :'users/follow_user', current_user.username, other_user.graph_user_id
    end

    describe 'followers' do
      it 'returns that the current user has no followers' do
        result = interactor :'users/followers', current_user.username, 0, 10

        expect(result[0].size).to eq 0
      end

      it 'returns that the other user has current_user as follower' do
        result = interactor :'users/followers', other_user.username, 0, 10

        expect(result[0].size).to eq 1
        expect(result[0][0].username).to eq current_user.username
      end
    end

    describe 'following' do
      it 'returns that the current user follow the other user' do
        result = interactor :'users/following', current_user.username, 0, 10

        expect(result[0].size).to eq 1
        expect(result[0][0].username).to eq other_user.username
      end

      it 'returns that the other user is not following users' do
        result = interactor :'users/following', other_user.username, 0, 10

        expect(result[0].size).to eq 0
      end
    end
  end
end
