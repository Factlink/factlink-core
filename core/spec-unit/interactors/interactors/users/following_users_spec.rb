require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/users/following_users'

describe Interactors::Users::FollowingUsers do
  include PavlovSupport

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
      interactor = described_class.new user_id

      expect(interactor).to_not be_nil
    end
  end

  describe '#authorized?' do
    before do
      described_class.any_instance.
        should_receive(:validate).
        and_return(true)
    end

    it 'throws when no current_user' do
      user_id = mock

      expect { described_class.new user_id }.
        to raise_error Pavlov::AccessDenied,'Unauthorized'
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

      described_class.any_instance.should_receive(:validate_hexadecimal_string).with(:user_id, user_id)

      interactor = described_class.new user_id
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

    it 'it calls the query to get a list of followed users' do
      user_id = mock
      interactor = described_class.new user_id
      user_ids = mock

      interactor.should_receive(:query).
        with(:'users/following_user_ids', user_id).
        and_return(user_ids)

      returned_user_ids = interactor.execute

      expect(returned_user_ids).to eq user_ids
    end
  end
end
