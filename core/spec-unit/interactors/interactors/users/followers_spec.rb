require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/users/followers'

describe Interactors::Users::Followers do
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
      current_user = mock(id: mock)
      interactor = described_class.new user_name, skip, take, current_user: current_user
      users = mock(length: mock)
      count = mock
      user = mock(id: mock)
      followed_by_me = true

      interactor.should_receive(:query).
        with(:'user_by_username', user_name).
        and_return(user)
      interactor.should_receive(:query).
        with(:'users/follower_ids', user.id).
        and_return(users)
      users.should_receive(:include?).with(current_user.id).and_return(followed_by_me)
      users.should_receive(:drop).with(skip).and_return(users)
      users.should_receive(:take).with(take).and_return(users)

      returned_users, returned_count, returned_followed_by_me = interactor.execute

      expect(returned_users).to eq users
      expect(returned_count).to eq users.length
      expect(returned_followed_by_me).to eq followed_by_me
    end
  end
end
