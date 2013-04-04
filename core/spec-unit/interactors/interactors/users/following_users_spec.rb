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
      interactor = described_class.new mock, mock, mock

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
      expect { described_class.new mock, mock, mock }.
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
      user_name = mock
      skip = mock
      take = mock

      described_class.any_instance.should_receive(:validate_nonempty_string).
        with(:user_name, user_name)
      described_class.any_instance.should_receive(:validate_integer).
        with(:skip, skip)
      described_class.any_instance.should_receive(:validate_integer).
        with(:take, take)

      interactor = described_class.new user_name, skip, take
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
      user_name = mock
      skip = mock
      take = mock
      interactor = described_class.new user_name, skip, take
      users = mock
      count = mock
      user = mock(id: mock)

      interactor.should_receive(:query).
        with(:'user_by_username', user_name).
        and_return(user)
      interactor.should_receive(:query).
        with(:'users/following_user_ids', user.id, skip, take).
        and_return(users)
      interactor.should_receive(:query).
        with(:'users/following_count', user.id).
        and_return(count)

      returned_users, returned_count = interactor.execute

      expect(returned_users).to eq users
      expect(returned_count).to eq count
    end
  end
end
