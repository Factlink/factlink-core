require 'spec_helper'

describe 'user following' do
  include PavlovSupport

  let(:user1) { create :user }
  let(:user2) { create :user }
  let(:user3) { create :user }

  describe 'following a user' do
    describe 'followers' do
      before do
        as(user1) do |pavlov|
          pavlov.old_interactor :'users/follow_user', user1.username, user2.username
          pavlov.old_interactor :'users/follow_user', user1.username, user3.username
        end
      end

      it 'returns that the current user has no followers' do
        as(user1) do |pavlov|
          result = pavlov.old_interactor :'users/followers', user1.username, 0, 10
          expect(result[0].size).to eq 0
        end
      end

      it 'returns that the other user has user1 as follower' do
        as(user1) do |pavlov|
          result = pavlov.old_interactor :'users/followers', user2.username, 0, 10
          expect(result[0].size).to eq 1
          expect(result[0][0].username).to eq user1.username
        end
      end
    end

    describe 'following' do
      before do
        as(user1) do |pavlov|
          pavlov.old_interactor :'users/follow_user', user1.username, user2.username
          pavlov.old_interactor :'users/follow_user', user1.username, user3.username
        end
      end

      it 'returns that the current user follows user2 and user3' do
        as(user1) do |pavlov|
          result = pavlov.old_interactor :'users/following', user1.username, 0, 10
          expect(result[0].size).to eq 2
          expect(result[0][0].username).to eq user2.username
          expect(result[0][1].username).to eq user3.username
        end
      end

      it 'returns that the other user is not following users' do
        as(user1) do |pavlov|
          result = pavlov.old_interactor :'users/following', user2.username, 0, 10
          expect(result[0].size).to eq 0
        end
      end
    end

    describe 'stream activities' do
      it "adds relevant activities" do
        a1, a2, a3, a4 = ()

        as(user2) do |pavlov|
          fact = pavlov.old_interactor :'facts/create', 'test', '', '', {}
          channel = pavlov.old_command :'channels/create', 'henk'

          a1 = Activity::Subject.activity user2.graph_user,
            :somethings, fact

          a2 = Activity::Subject.activity user2.graph_user,
            :added_fact_to_channel, fact,
            :to, channel

          a3 = Activity::Subject.activity user2.graph_user,
            :something_elses, fact

          a4 = Activity::Subject.activity user2.graph_user,
            :followed_user, user3.graph_user
        end

        as(user1) do |pavlov|
          pavlov.old_interactor :'users/follow_user', user1.username, user2.username
        end

        expect(user1.graph_user.stream_activities.ids)
          .to match_array [a2.id, a4.id]
      end
    end
  end

  describe 'unfollowing a user' do
    before do
      as(user1) do |pavlov|
        pavlov.old_interactor :'users/follow_user', user1.username, user2.username
        pavlov.old_interactor :'users/unfollow_user', user1.username, user2.username
      end
    end

    describe 'followers' do
      it 'returns that the current user has no followers' do
        as(user1) do |pavlov|
          result = pavlov.old_interactor :'users/followers', user1.username, 0, 10
          expect(result[0].size).to eq 0
        end
      end

      it 'returns that the other user has no followers' do
        as(user1) do |pavlov|
          result = pavlov.old_interactor :'users/followers', user2.username, 0, 10
          expect(result[0].size).to eq 0
        end
      end
    end

    describe 'following' do
      it 'returns that the current user is not following users' do
        as(user1) do |pavlov|
          result = pavlov.old_interactor :'users/following', user1.username, 0, 10
          expect(result[0].size).to eq 0
        end
      end

      it 'returns that the other user is not following users' do
        as(user1) do |pavlov|
          result = pavlov.old_interactor :'users/following', user2.username, 0, 10
          expect(result[0].size).to eq 0
        end
      end
    end
  end

  describe 'unfollowing, following multiple times' do
    before do
      as(user1) do |pavlov|
        pavlov.old_interactor :'users/unfollow_user', user1.username, user2.username
        pavlov.old_interactor :'users/follow_user', user1.username, user2.username
        pavlov.old_interactor :'users/follow_user', user1.username, user2.username
      end
    end

    describe 'followers' do
      it 'returns that the current user has no followers' do
        as(user1) do |pavlov|
          result = pavlov.old_interactor :'users/followers', user1.username, 0, 10
          expect(result[0].size).to eq 0
        end
      end

      it 'returns that the other user has user1 as follower' do
        as(user1) do |pavlov|
          result = pavlov.old_interactor :'users/followers', user2.username, 0, 10
          expect(result[0].size).to eq 1
          expect(result[0][0].username).to eq user1.username
        end
      end
    end

    describe 'following' do
      it 'returns that the current user follow the other user' do
        as(user1) do |pavlov|
          result = pavlov.old_interactor :'users/following', user1.username, 0, 10
          expect(result[0].size).to eq 1
          expect(result[0][0].username).to eq user2.username
        end
      end

      it 'returns that the other user is not following users' do
        as(user1) do |pavlov|
          result = pavlov.old_interactor :'users/following', user2.username, 0, 10
          expect(result[0].size).to eq 0
        end
      end
    end
  end

  describe 'following yourself' do
    it 'should not be allowed' do
      as(user1) do |pavlov|
        expect {pavlov.old_interactor :'users/follow_user', user1.username, user1.username}.
          to raise_error
      end
    end

    it 'should have no followers and following' do
      as(user1) do |pavlov|
        begin
          pavlov.old_interactor :'users/follow_user', user1.username, user1.username
        rescue
        end

        followers = pavlov.old_interactor :'users/followers', user1.username, 0, 10
        expect(followers[0].size).to eq 0

        following = pavlov.old_interactor :'users/following', user1.username, 0, 10
        expect(following[0].size).to eq 0
      end
    end
  end

  describe 'posing as someone else' do
    it 'should not be allowed' do
      as(user1) do |pavlov|
        expect {pavlov.old_interactor :'users/follow_user', user2.username, user3.username}.
          to raise_error
      end
    end

    it 'should have no followers and following' do
      as(user1) do |pavlov|
        expect {pavlov.old_interactor :'users/follow_user', user2.username, user3.username}.
          to raise_error

        followers = pavlov.old_interactor :'users/followers', user2.username, 0, 10
        expect(followers[0].size).to eq 0

        following = pavlov.old_interactor :'users/following', user2.username, 0, 10
        expect(following[0].size).to eq 0
      end
    end
  end
end
