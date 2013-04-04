require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/users/follow_user'

describe Interactors::Users::FollowUser do
  include PavlovSupport

  describe '#authorized?' do
    before do
      described_class.any_instance.
        should_receive(:validate).
        and_return(true)
    end

    it 'throws when no current_user' do
      user_id = mock
      user_to_follow_id = mock

      expect { described_class.new user_id, user_to_follow_id }.
        to raise_error Pavlov::AccessDenied,'Unauthorized'
    end
  end

  describe '.new' do
    before do
      described_class.any_instance.
        should_receive(:authorized?).
        and_return(true)
      described_class.any_instance.
        should_receive(:validate).
        and_return(true)
    end

    it 'returns an object' do
      user_id = mock
      user_to_follow_id = mock
      interactor = described_class.new user_id, user_to_follow_id

      expect(interactor).to_not be_nil
    end
  end

  describe '#execute' do
    before do
      described_class.any_instance.
        should_receive(:authorized?).
        and_return(true)
      described_class.any_instance.
        should_receive(:validate).
        and_return(true)
    end

    it 'calls a command to follow user and returns the user' do
      user_id = mock
      user_to_follow_id = mock

      interactor = described_class.new user_id, user_to_follow_id
      interactor.should_receive(:command).
        with(:'users/follow_user', user_id, user_to_follow_id).
        and_return(mock)

      result = interactor.execute

      expect(result).to eq nil
    end
  end

  describe '#validate' do
    before do
      described_class.any_instance.
        should_receive(:authorized?).
        and_return(true)
    end

    it 'calls the correct validation methods' do
      user_id = mock
      user_to_follow_id = mock

      described_class.any_instance.should_receive(:validate_hexadecimal_string).with(:user_id, user_id)
      described_class.any_instance.should_receive(:validate_hexadecimal_string).with(:user_to_follow_id, user_to_follow_id)

      interactor = described_class.new user_id, user_to_follow_id
    end
  end
end
