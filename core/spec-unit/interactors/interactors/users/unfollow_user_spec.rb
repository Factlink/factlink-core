require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/users/unfollow_user'

describe Interactors::Users::UnfollowUser do
  include PavlovSupport

  describe '#authorized?' do
    before do
      described_class.any_instance.stub(validate: true)
    end

    it 'throws when no current_user' do
      expect { described_class.new mock, mock }.
        to raise_error Pavlov::AccessDenied,'Unauthorized'
    end

    it 'throws when updating someone else\'s follow' do
      username = mock
      other_username = mock
      current_user = mock(username: username)

      expect { described_class.new other_username, mock, {current_user: current_user} }.
        to raise_error Pavlov::AccessDenied,'Unauthorized'
    end

    it 'doesn\'t throw when updating your own follow' do
      username = mock
      current_user = mock(username: username)

      described_class.new username, mock, {current_user: current_user}
    end
  end

  describe '.new' do
    before do
      described_class.any_instance.stub(authorized?: true, validate: true)
    end

    it 'returns an object' do
      interactor = described_class.new mock, mock

      expect(interactor).to_not be_nil
    end
  end

  describe '#execute' do
    before do
      described_class.any_instance.stub(authorized?: true, validate: true)
    end

    it 'calls a command to unfollow' do
      user_name = mock
      user_to_unfollow_user_name = mock
      interactor = described_class.new user_name, user_to_unfollow_user_name
      user = mock(graph_user_id: mock)
      user_to_unfollow = mock(graph_user_id: mock)

      interactor.should_receive(:old_query).
        with(:'user_by_username', user_name).
        and_return(user)
      interactor.should_receive(:old_query).
        with(:'user_by_username', user_to_unfollow_user_name).
        and_return(user_to_unfollow)
      interactor.should_receive(:old_command).
        with(:'users/unfollow_user', user.graph_user_id, user_to_unfollow.graph_user_id)

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
      user_to_unfollow_user_name = mock

      described_class.any_instance.should_receive(:validate_nonempty_string).
        with(:user_name, user_name)
      described_class.any_instance.should_receive(:validate_nonempty_string).
        with(:user_to_unfollow_user_name, user_to_unfollow_user_name)

      interactor = described_class.new user_name, user_to_unfollow_user_name
    end
  end
end
