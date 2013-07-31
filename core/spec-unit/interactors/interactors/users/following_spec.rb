require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/users/following'

describe Interactors::Users::Following do
  include PavlovSupport

  describe '.new' do
    before do
      described_class.any_instance.stub(authorized?: true, validate: true)
    end

    it 'returns an object' do
      interactor = described_class.new mock, mock, mock

      expect(interactor).to_not be_nil
    end
  end

  describe '#authorized?' do
    before do
      described_class.any_instance.stub(validate: true)
    end

    it 'throws when no current_user' do
      expect { described_class.new mock, mock, mock }.
        to raise_error Pavlov::AccessDenied,'Unauthorized'
    end
  end

  describe '#validate' do
    before do
      described_class.any_instance.stub(authorized?: true)
    end

    it 'calls the correct validation methods' do
      user_name = double
      skip = double
      take = double

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
      described_class.any_instance.stub(authorized?: true, validate: true)
    end

    it 'it calls the query to get a list of followed users' do
      user_name = double
      skip = double
      take = double
      interactor = described_class.new user_name, skip, take
      users = mock(length: mock)
      graph_user_ids = double
      count = double
      user = mock(graph_user_id: mock)

      interactor.should_receive(:old_query).
        with(:'user_by_username', user_name).
        and_return(user)
      interactor.should_receive(:old_query).
        with(:'users/following_graph_user_ids', user.graph_user_id.to_s).
        and_return(graph_user_ids)
      interactor.should_receive(:old_query).
        with(:users_by_graph_user_ids, graph_user_ids).
        and_return(users)


      users.should_receive(:drop).with(skip).and_return(users)
      users.should_receive(:take).with(take).and_return(users)

      returned_users, returned_count = interactor.execute

      expect(returned_users).to eq users
      expect(returned_count).to eq users.length
    end
  end
end
