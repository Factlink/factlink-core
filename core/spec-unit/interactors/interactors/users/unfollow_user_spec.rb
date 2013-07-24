require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/users/unfollow_user'

describe Interactors::Users::UnfollowUser do
  include PavlovSupport

  describe '#authorized?' do
    before do
      described_class.any_instance.stub(validate: true)
    end

    it 'throws when no current_user' do
      expect do
        described_class.new(user_name: mock,
          user_to_unfollow_user_name: mock).call
      end.to raise_error Pavlov::AccessDenied, 'Unauthorized'
    end

    it 'throws when updating someone else\'s follow' do
      username = mock
      other_username = mock
      current_user = mock(username: username)

      expect do
        described_class.new(user_name: other_username, user_to_unfollow_user_name: mock, pavlov_options:  {current_user: current_user}).call
      end.to raise_error Pavlov::AccessDenied,'Unauthorized'
    end
  end

  describe '#call' do
    before do
      described_class.any_instance.stub(authorized?: true, validate: true)
    end

    it 'calls a command to unfollow' do
      user_name = mock
      user_to_unfollow_user_name = mock
      user = mock(graph_user_id: mock)
      user_to_unfollow = mock(graph_user_id: mock)
      interactor = described_class.new user_name: user_name,
        user_to_unfollow_user_name: user_to_unfollow_user_name

      interactor.should_receive(:old_query).
        with(:'user_by_username', user_name).
        and_return(user)
      interactor.should_receive(:old_query).
        with(:'user_by_username', user_to_unfollow_user_name).
        and_return(user_to_unfollow)
      interactor.should_receive(:old_command).
        with(:'users/unfollow_user', user.graph_user_id, user_to_unfollow.graph_user_id)

      expect(interactor.call).to eq nil
    end
  end

  describe 'validations' do
    it 'validates user_name' do
      interactor = described_class.new user_name: 12, user_to_unfollow_user_name: 'name'

      expect{ interactor.call }.to raise_error(Pavlov::ValidationError,
        'user_name should be a nonempty string.')
    end

    it 'validates user_name' do
      interactor = described_class.new user_name: 'name', user_to_unfollow_user_name: 12

      expect{ interactor.call }.to raise_error(Pavlov::ValidationError,
        'user_to_unfollow_user_name should be a nonempty string.')
    end
  end
end
