require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/users/following'

describe Interactors::Users::Following do
  include PavlovSupport

  describe '#authorized?' do
    it 'throws when no current_user' do
      expect do
        interactor = described_class.new(user_name: 'gerard', skip: 2, take: 7)
        interactor.call
      end.to raise_error Pavlov::AccessDenied,'Unauthorized'
    end
  end

  describe 'validations' do
    it 'invalid user_name doesn\t validate' do
      expect_validating(user_name: 1)
        .to fail_validation('user_name should be a nonempty string.')
    end

    it 'invalid skip doesn\t validate' do
      expect_validating(skip: 'thirteen')
        .to fail_validation('skip should be an integer.')
    end

    it 'invalid take doesn\t validate' do
      expect_validating(take: 'about two')
        .to fail_validation('take should be an integer.')
    end
  end

  describe '#call' do
    it 'it calls the query to get a list of followed users' do
      users = [double, double, double, double, double, double]
      skip = 2
      take = 3
      graph_user_ids = [1, 4, 5, 6, 2, 3]
      user = double(graph_user_id: double, username: 'henk')

      pavlov_options = { current_user: double}
      interactor = described_class.new user_name: user.username, skip: skip, take: take, pavlov_options: pavlov_options

      allow(Pavlov).to receive(:query)
        .with(:'user_by_username', username: user.username, pavlov_options: pavlov_options)
        .and_return(user)
      allow(Pavlov).to receive(:query)
        .with(:'users/following_graph_user_ids',
              graph_user_id: user.graph_user_id.to_s, pavlov_options: pavlov_options)
        .and_return(graph_user_ids)
      allow(Pavlov).to receive(:query)
        .with(:'users_by_ids',
              user_ids: graph_user_ids, by: :graph_user_id, pavlov_options: pavlov_options)
        .and_return(users)
      allow(Pavlov).to receive(:query)
        .with(:'users_by_ids',
              user_ids: graph_user_ids.sort[skip, take], by: :graph_user_id, pavlov_options: pavlov_options)
        .and_return(users[skip, take])

      returned_users, returned_count = interactor.call

      expect(returned_users).to eq users[skip, take]
      expect(returned_count).to eq users.length
    end
  end
end
