require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/users/following'

describe Interactors::Users::Following do
  include PavlovSupport

  describe '#authorized?' do
    before do
      described_class.any_instance.stub(validate: true)
    end

    it 'throws when no current_user' do
      expect do
        interactor = described_class.new(user_name: mock, skip: mock, take: mock)
        interactor.call
      end.to raise_error Pavlov::AccessDenied,'Unauthorized'
    end
  end

  describe 'validations' do
    before do
      described_class.any_instance.stub(authorized?: true)
    end

    it 'invalid user_name doesn\t validate' do
      expect_validating(user_name: 1, skip: 1, take: 2)
        .to fail_validation('user_name should be a nonempty string.')
    end

    it 'invalid skip doesn\t validate' do
      expect_validating(user_name: 'karel', skip: 'thirteen', take: 2)
        .to fail_validation('skip should be an integer.')
    end

    it 'invalid take doesn\t validate' do
      expect_validating(user_name: 'karel', skip: 1, take: 'about two')
        .to fail_validation('take should be an integer.')
    end
  end

  describe '#call' do
    before do
      described_class.any_instance.stub(authorized?: true, validate: true)
    end

    it 'it calls the query to get a list of followed users' do
      user_name = mock
      skip = mock
      take = mock
      interactor = described_class.new user_name: user_name, skip: skip, take: take
      users = mock(length: mock)
      graph_user_ids = mock
      count = mock
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

      returned_users, returned_count = interactor.call

      expect(returned_users).to eq users
      expect(returned_count).to eq users.length
    end
  end
end
