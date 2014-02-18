require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/users/follow_user'

describe Interactors::Users::FollowUser do
  include PavlovSupport

  describe '#authorized?' do
    it 'throws when no current_user' do
      pavlov_options = {}
      expect do
        described_class.new(user_to_follow_username: 'foo', pavlov_options: pavlov_options).call
      end.to raise_error Pavlov::AccessDenied,'Unauthorized'
    end
  end

  describe '#call' do
    it 'calls a command to follow user' do
      user = double(id: '1a', graph_user_id: '10', graph_user: double, username: 'user')
      user_to_follow = double(graph_user_id: '20', graph_user: double, username: 'user_to_follow')
      options = {current_user: user}
      interactor = described_class.new(user_to_follow_username: user_to_follow.username, pavlov_options: options)

      Pavlov.stub(:query)
            .with(:'user_by_username',
                      username: user_to_follow.username, pavlov_options: options)
            .and_return(user_to_follow)
      Pavlov.stub(:query)
            .with(:'users/user_follows_user', from_graph_user_id: user.graph_user_id,
                                              to_graph_user_id: user_to_follow.graph_user_id, pavlov_options: options)
            .and_return(false)

      Pavlov.should_receive(:command)
            .with(:'users/follow_user',
                      graph_user_id: user.graph_user_id,
                      user_to_follow_graph_user_id: user_to_follow.graph_user_id,
                      pavlov_options: options)
      Pavlov.should_receive(:command)
            .with(:'create_activity',
                      graph_user: user.graph_user, action: :followed_user,
                      subject: user_to_follow.graph_user, object: nil,
                      pavlov_options: options)
      Pavlov.should_receive(:command)
            .with(:'stream/add_activities_of_user_to_stream',
                      graph_user_id: user_to_follow.graph_user_id,
                      pavlov_options: options)

      interactor.call
    end

    it 'aborts when already following' do
      user = double(id: '1a', graph_user_id: '10', graph_user: double, username: 'user')
      user_to_follow = double(graph_user_id: '20', graph_user: double, username: 'user_to_follow')
      options = {current_user: user}
      interactor = described_class.new(username: user.username,
                                       user_to_follow_username: user_to_follow.username, pavlov_options: options)

      Pavlov.stub(:query)
            .with(:'user_by_username', username: user_to_follow.username, pavlov_options: options)
            .and_return(user_to_follow)
      Pavlov.stub(:query)
            .with(:'users/user_follows_user', from_graph_user_id: user.graph_user_id,
                                              to_graph_user_id: user_to_follow.graph_user_id, pavlov_options: options)
            .and_return(true)

      interactor.call
    end
  end

  describe 'validations' do
    let(:pavlov_options) do
      { current_user: double(username: 'karel') }
    end
    it 'with a invalid user_to_follow_username doesn\t validate' do
      expect_validating(user_to_follow_username: 12, pavlov_options: pavlov_options)
        .to fail_validation('user_to_follow_username should be a nonempty string.')
    end

    it 'you don\'t try to follow yourself' do
      expect do
        described_class.new(user_to_follow_username: 'karel', pavlov_options: pavlov_options).call
      end.to raise_error
    end
  end
end
