require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/users/follow_user'

describe Interactors::Users::FollowUser do
  include PavlovSupport

  before do
    stub_classes 'Backend::Activities', 'Backend::UserFollowers'
  end

  describe '#authorized?' do
    it 'throws when no current_user' do
      pavlov_options = {}
      expect do
        described_class.new(username: 'foo', pavlov_options: pavlov_options).call
      end.to raise_error Pavlov::AccessDenied,'Unauthorized'
    end
  end

  describe '#call' do
    it 'calls a command to follow user' do
      user = double(id: '1a', graph_user_id: '10', graph_user: double, username: 'user')
      user_to_follow = double(graph_user_id: '20', graph_user: double, username: 'user_to_follow')
      options = {current_user: user}
      interactor = described_class.new(username: user_to_follow.username, pavlov_options: options)

      Pavlov.stub(:query)
            .with(:'user_by_username',
                      username: user_to_follow.username, pavlov_options: options)
            .and_return(user_to_follow)

      allow(Backend::UserFollowers).to receive(:following?)
            .with(follower_id: user.graph_user_id,
                  followee_id: user_to_follow.graph_user_id)
            .and_return(false)

      expect(Backend::UserFollowers).to receive(:follow)
            .with(follower_id: user.graph_user_id,
                  followee_id: user_to_follow.graph_user_id)

      Backend::Activities.should_receive(:create)
                  .with(graph_user: user.graph_user,
                        action: :followed_user,
                        subject: user_to_follow.graph_user)
      Backend::Activities.should_receive(:add_activities_to_follower_stream)
            .with(followed_user_graph_user_id: user_to_follow.graph_user_id,
                  current_graph_user_id: user.graph_user_id)

      interactor.call
    end

    it 'aborts when already following' do
      user = double(id: '1a', graph_user_id: '10', graph_user: double, username: 'user')
      user_to_follow = double(graph_user_id: '20', graph_user: double, username: 'user_to_follow')
      options = {current_user: user}
      interactor = described_class.new(username: user_to_follow.username, pavlov_options: options)

      Pavlov.stub(:query)
            .with(:'user_by_username', username: user_to_follow.username, pavlov_options: options)
            .and_return(user_to_follow)
      allow(Backend::UserFollowers).to receive(:following?)
            .with(follower_id: user.graph_user_id,
                  followee_id: user_to_follow.graph_user_id)
            .and_return(true)

      interactor.call
    end
  end

  describe 'validations' do
    let(:pavlov_options) do
      { current_user: double(username: 'karel') }
    end
    it 'with a invalid username doesn\t validate' do
      expect_validating(username: 12, pavlov_options: pavlov_options)
        .to fail_validation('username should be a nonempty string.')
    end

    it 'you don\'t try to follow yourself' do
      expect do
        described_class.new(username: 'karel', pavlov_options: pavlov_options).call
      end.to raise_error
    end
  end
end
