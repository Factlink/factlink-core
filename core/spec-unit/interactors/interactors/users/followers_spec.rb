require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/users/followers'

describe Interactors::Users::Followers do
  include PavlovSupport

  describe '#authorized?' do
    it 'throws when no current_user' do
      expect do
        described_class.new(user_name: 'henk', skip: 3, take: 5).call
      end.to raise_error(Pavlov::AccessDenied, 'Unauthorized')
    end
  end

  describe '#validate' do
    it 'without user_id doesn\'t validate' do
      expect_validating(user_name: 12)
        .to fail_validation('user_name should be a nonempty string.')
    end

    it 'without user_id doesn\'t validate' do
      expect_validating(skip: 'a')
        .to fail_validation('skip should be an integer.')
    end

    it 'without user_id doesn\'t validate' do
      expect_validating(take: 'b')
        .to fail_validation('take should be an integer.')
    end
  end

  describe '#call' do
    it 'it calls the query to get a list of followed users' do
      current_user = double(graph_user_id: 13)
      graph_user_ids = [1, 3, 8, current_user.graph_user_id, 5, 9]
      users = graph_user_ids.map { |id| double graph_user_id: id}
      following_user = double(graph_user_id: 5, username: 'henk')

      pavlov_options = { current_user: current_user }
      interactor = described_class.new(user_name: following_user.username,
                                       skip: 2,
                                       take: 3,
                                       pavlov_options: pavlov_options)

      allow(Pavlov).to receive(:query)
        .with(:'user_by_username', username: following_user.username, pavlov_options: pavlov_options)
        .and_return(following_user)
      allow(Pavlov).to receive(:query)
        .with(:'users/follower_graph_user_ids',
              graph_user_id: following_user.graph_user_id.to_s,
              pavlov_options: pavlov_options)
        .and_return(graph_user_ids)
      allow(Pavlov).to receive(:query)
        .with(:'users_by_ids',
              user_ids: anything,
              by: :graph_user_id,
              pavlov_options: pavlov_options) do |cmd, options|
          options[:user_ids].map do |id|
            users.select {|user| user.graph_user_id == id}.first
          end
        end

      returned_users, returned_count, returned_followed_by_me = interactor.call

      users_page = users.sort_by(&:graph_user_id).drop(2).take(3)
      expect(returned_users).to eq users_page
      expect(returned_count).to eq users.length
      expect(returned_followed_by_me).to eq true
    end
  end
end
