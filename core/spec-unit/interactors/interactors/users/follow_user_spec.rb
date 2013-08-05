require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/users/follow_user'

describe Interactors::Users::FollowUser do
  include PavlovSupport

  describe '#authorized?' do
    before do
      described_class.any_instance
        .should_receive(:validate)
        .and_return(true)
    end

    it 'throws when no current_user' do
      expect do
        described_class.new(user_name: double, user_to_follow_user_name: double).call
      end.to raise_error Pavlov::AccessDenied,'Unauthorized'
    end

    it 'throws when updating someone else\'s follow' do
      username = double
      other_username = double
      current_user = double(username: username)
      options = {current_user: current_user}
      interactor = described_class.new(user_name: other_username,
        user_to_follow_user_name: double, pavlov_options: options)

      expect do
        interactor.call
      end.to raise_error Pavlov::AccessDenied,'Unauthorized'
    end
  end

  describe '#call' do
    before do
      described_class.any_instance.stub(authorized?: true, validate: true)
    end

    it 'calls a command to follow user' do
      user = double(id: double, graph_user_id: double, graph_user: double, username: double)
      user_to_follow = double(graph_user_id: double, graph_user: double, username: double)
      options = { current_user: user }
      interactor = described_class.new(user_name: user.username,
        user_to_follow_user_name: user_to_follow.username, pavlov_options: options)

      interactor.should_receive(:old_query)
        .with(:'user_by_username', user.username)
        .and_return(user)
      interactor.should_receive(:old_query)
        .with(:'user_by_username', user_to_follow.username)
        .and_return(user_to_follow)
      interactor.should_receive(:old_command)
        .with(:'users/follow_user', user.graph_user_id, user_to_follow.graph_user_id)
      interactor.should_receive(:old_command)
        .with(:'create_activity', user.graph_user, :followed_user, user_to_follow.graph_user, nil)
      interactor.should_receive(:old_command)
        .with(:'stream/add_activities_of_user_to_stream', user_to_follow.graph_user_id)

      expect(interactor.call).to eq nil
    end
  end

  describe 'validations' do
    it 'with a invalid user_name doesn\t validate' do
      expect_validating(user_name: 12, user_to_follow_user_name: 'karel')
        .to fail_validation('user_name should be a nonempty string.')
    end

    it 'with a invalid user_to_follow_user_name doesn\t validate' do
      expect_validating(user_name: 'karel', user_to_follow_user_name: 12)
        .to fail_validation('user_to_follow_user_name should be a nonempty string.')
    end

    it 'you don\'t try to follow yourself' do
      expect_validating(user_name: 'karel', user_to_follow_user_name: 'karel')
        .to fail_validation('You cannot follow yourself.')
    end
  end
end
