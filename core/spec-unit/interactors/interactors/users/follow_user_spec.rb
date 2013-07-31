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
      expect { described_class.new mock, mock }
        .to raise_error Pavlov::AccessDenied,'Unauthorized'
    end

    it 'throws when updating someone else\'s follow' do
      username = mock
      other_username = mock
      current_user = mock(username: username)

      expect { described_class.new other_username, mock, {current_user: current_user} }
        .to raise_error Pavlov::AccessDenied,'Unauthorized'
    end

    it 'doesn\'t throw when updating your own follow' do
      username = mock
      current_user = mock(username: username)

      described_class.new username, mock, {current_user: current_user}
    end
  end

  describe '#execute' do
    before do
      described_class.any_instance.stub(authorized?: true, validate: true)
    end

    it 'calls a command to follow user' do
      user = mock(id: mock, graph_user_id: mock, graph_user: mock, username: mock)
      user_to_follow = mock(graph_user_id: mock, graph_user: mock, username: mock)

      interactor = described_class.new user.username, user_to_follow.username, current_user: user

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

      result = interactor.execute

      expect(result).to eq nil
    end
  end

  describe '#validate' do
    before do
      described_class.any_instance.stub(authorized?: true)
    end

    it 'calls the correct validation methods' do
      user_name = mock
      user_to_follow_user_name = mock

      described_class.any_instance.should_receive(:validate_nonempty_string)
        .with(:user_name, user_name)
      described_class.any_instance.should_receive(:validate_nonempty_string)
        .with(:user_to_follow_user_name, user_to_follow_user_name)

      interactor = described_class.new user_name, user_to_follow_user_name
    end

    it 'calls the correct validation methods' do
      user_name = mock

      described_class.any_instance.stub(:validate_nonempty_string)

      expect {described_class.new user_name, user_name}.
        to raise_error(Pavlov::ValidationError, "You cannot follow yourself.")
    end
  end
end
